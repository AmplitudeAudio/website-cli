# Amplitude Audio CLI (am) installer for Windows.
#
#   irm https://cli.amplitudeaudiosdk.com/install.ps1 | iex                     # latest release
#   $env:AM_CHANNEL='beta'; irm https://cli.amplitudeaudiosdk.com/install.ps1 | iex      # latest prerelease
#   $env:AM_CHANNEL='nightly'; irm https://cli.amplitudeaudiosdk.com/install.ps1 | iex   # latest CI build of main
#
# Or, to pass switches instead of environment variables:
#   & ([scriptblock]::Create((irm https://cli.amplitudeaudiosdk.com/install.ps1))) -Beta
#   & ([scriptblock]::Create((irm https://cli.amplitudeaudiosdk.com/install.ps1))) -Nightly
#
# Environment variables:
#   AM_CHANNEL        stable (default), beta or nightly; the switches take precedence
#   AM_VERSION        Install an exact release, e.g. 0.1.0 or v0.1.0
#   AM_INSTALL_DIR    Where to put am.exe (default: $HOME\.amplitude\bin)
#   AM_REPO           GitHub repository to download from (default: AmplitudeAudio/cli)
#   AM_NIGHTLY_BASE   Base URL of the nightly artifacts
#                     (default: https://nightly.link/<repo>/workflows/nightly/main)
#   AM_NO_MODIFY_PATH Set to 1 to leave the user PATH untouched

param(
    [switch]$Beta,
    [switch]$Nightly
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

function Get-ReleaseTags($github) {
    # Newest-first release tags from the releases feed (prereleases included).
    $feed = (Invoke-WebRequest -Uri "$github/releases.atom" -UseBasicParsing).Content
    if ($feed -is [byte[]]) { $feed = [Text.Encoding]::UTF8.GetString($feed) }
    [regex]::Matches($feed, '/releases/tag/([^"<]+)"') | ForEach-Object { $_.Groups[1].Value }
}

function Get-LatestStableTag($github, $repo) {
    $tag = ''

    # Preferred: /releases/latest redirects to /releases/tag/<tag> (stable releases only).
    try {
        $response = Invoke-WebRequest -Uri "$github/releases/latest" -UseBasicParsing -MaximumRedirection 5
        $finalUrl = if ($response.BaseResponse.ResponseUri) {
            $response.BaseResponse.ResponseUri.AbsoluteUri      # Windows PowerShell
        } else {
            $response.BaseResponse.RequestMessage.RequestUri.AbsoluteUri   # PowerShell 7+
        }
        $tag = ($finalUrl -split '/')[-1]
    } catch { }

    # Fallback: the newest non-prerelease tag in the releases feed.
    if ($tag -notmatch '^v\d') {
        try {
            $tag = Get-ReleaseTags $github | Where-Object { $_ -match '^v\d' -and $_ -notmatch '-(alpha|beta|rc)' } | Select-Object -First 1
        } catch {
            throw "Could not query the latest release of ${repo}: $($_.Exception.Message)"
        }
    }
    if ($tag -notmatch '^v\d') { throw "No published release found at $github/releases." }
    return $tag
}

function Get-LatestBetaTag($github, $repo) {
    try {
        $tag = Get-ReleaseTags $github | Where-Object { $_ -match '^v\d.*-(alpha|beta|rc)' } | Select-Object -First 1
    } catch {
        throw "Could not query the releases of ${repo}: $($_.Exception.Message)"
    }
    if (-not $tag) { throw "No prerelease (alpha, beta or rc) found at $github/releases." }
    return $tag
}

function Assert-Checksum($path, $checksumPath) {
    $expected = ((Get-Content $checksumPath -Raw).Trim() -split '\s+')[0].ToLower()
    $actual = (Get-FileHash $path -Algorithm SHA256).Hash.ToLower()
    if (-not $expected -or $expected -ne $actual) {
        throw "Checksum mismatch for $(Split-Path -Leaf $path) (expected $expected, got $actual)."
    }
    Write-Host '+ Checksum verified' -ForegroundColor Green
}

function Install-AmplitudeCli {
    $repo = if ($env:AM_REPO) { $env:AM_REPO } else { 'AmplitudeAudio/cli' }
    $installDir = if ($env:AM_INSTALL_DIR) { $env:AM_INSTALL_DIR } else { Join-Path $HOME '.amplitude\bin' }
    $completionsDir = Join-Path (Split-Path -Parent $installDir) 'completions'
    $github = "https://github.com/$repo"
    $nightlyBase = if ($env:AM_NIGHTLY_BASE) { $env:AM_NIGHTLY_BASE } else { "https://nightly.link/$repo/workflows/nightly/main" }

    $channel = if ($env:AM_CHANNEL) { $env:AM_CHANNEL.ToLower() } else { 'stable' }
    if ($Beta -and $Nightly) { throw 'Use either -Beta or -Nightly, not both.' }
    if ($Beta) { $channel = 'beta' }
    if ($Nightly) { $channel = 'nightly' }
    if ($channel -notin 'stable', 'beta', 'nightly') {
        throw "Unknown channel '$channel'. Use stable, beta or nightly."
    }
    if ($env:AM_VERSION -and $channel -ne 'stable') {
        throw "AM_VERSION cannot be combined with the $channel channel."
    }

    # Older Windows PowerShell defaults to TLS 1.0/1.1, which GitHub rejects.
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

    $arch = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture.ToString()
    if ($arch -ne 'X64') {
        throw "Unsupported architecture: $arch. Only Windows x86_64 is published."
    }
    $target = 'x86_64-pc-windows-msvc'

    $tmp = Join-Path ([IO.Path]::GetTempPath()) "am-install-$([Guid]::NewGuid().ToString('N'))"
    New-Item -ItemType Directory -Path $tmp | Out-Null
    try {
        $extractDir = Join-Path $tmp 'extract'

        if ($channel -eq 'nightly') {
            $label = 'nightly'
            Write-Host "Installing Amplitude CLI nightly ($target)"

            $artifact = "am-nightly-$target"
            $url = "$nightlyBase/$artifact.zip"
            $outerZip = Join-Path $tmp 'outer.zip'
            try {
                Invoke-WebRequest -Uri $url -OutFile $outerZip -UseBasicParsing
            } catch {
                throw "Download failed from $url. No nightly build is available for $target yet; use the default channel or -Beta instead. ($($_.Exception.Message))"
            }
            $outerDir = Join-Path $tmp 'outer'
            Expand-Archive -Path $outerZip -DestinationPath $outerDir -Force

            # CI artifacts hold the release-style archive (and its checksum) inside the outer zip.
            $inner = Join-Path $outerDir "$artifact.zip"
            if (Test-Path $inner) {
                if (Test-Path "$inner.sha256") { Assert-Checksum $inner "$inner.sha256" }
                Expand-Archive -Path $inner -DestinationPath $extractDir -Force
            } else {
                Move-Item $outerDir $extractDir
            }
        } else {
            $version = $env:AM_VERSION
            if (-not $version) {
                Write-Host "Looking up the latest $channel release..."
                $version = if ($channel -eq 'beta') { Get-LatestBetaTag $github $repo } else { Get-LatestStableTag $github $repo }
            }
            $version = $version.TrimStart('v')
            $label = "v$version"

            Write-Host "Installing Amplitude CLI v$version ($target)"

            $archive = "am-v$version-$target.zip"
            $baseUrl = "$github/releases/download/v$version"
            $zipPath = Join-Path $tmp $archive
            try {
                Invoke-WebRequest -Uri "$baseUrl/$archive" -OutFile $zipPath -UseBasicParsing
                Invoke-WebRequest -Uri "$baseUrl/$archive.sha256" -OutFile "$zipPath.sha256" -UseBasicParsing
            } catch {
                throw "Download failed from $baseUrl. Release v$version may not be published yet, or has no build for $target. See $github/releases. ($($_.Exception.Message))"
            }
            Assert-Checksum $zipPath "$zipPath.sha256"
            Expand-Archive -Path $zipPath -DestinationPath $extractDir -Force
        }

        $exe = Get-ChildItem -Path $extractDir -Recurse -Filter 'am.exe' -File | Select-Object -First 1
        if (-not $exe) { throw 'The archive does not contain am.exe.' }

        New-Item -ItemType Directory -Path $installDir -Force | Out-Null
        $dest = Join-Path $installDir 'am.exe'
        try {
            Copy-Item $exe.FullName $dest -Force
        } catch {
            throw "Could not write $dest. Close any running 'am' process and try again."
        }
        Write-Host "+ Installed am.exe $label to $dest" -ForegroundColor Green

        $completionsSrc = Join-Path $exe.DirectoryName 'completions'
        if (Test-Path $completionsSrc) {
            New-Item -ItemType Directory -Path $completionsDir -Force | Out-Null
            Copy-Item (Join-Path $completionsSrc '*') $completionsDir -Force
            Write-Host "+ Shell completions copied to $completionsDir" -ForegroundColor Green
        }
    } finally {
        Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
    }

    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    $entries = if ($userPath) { $userPath -split ';' | Where-Object { $_ } } else { @() }
    $onPath = $entries | Where-Object { $_.TrimEnd('\') -ieq $installDir.TrimEnd('\') }

    Write-Host ''
    if ($onPath) {
        Write-Host 'Run "am --help" to get started.'
    } elseif ($env:AM_NO_MODIFY_PATH -eq '1') {
        Write-Host "$installDir is not in your PATH. Add it to your user PATH, then run `"am --help`"."
    } else {
        $newPath = (@($entries) + $installDir) -join ';'
        [Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
        $env:Path = "$env:Path;$installDir"
        Write-Host "Added $installDir to your user PATH."
        Write-Host 'Restart your terminal, then run "am --help" to get started.'
    }
}

Install-AmplitudeCli
