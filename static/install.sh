#!/bin/sh
# Amplitude Audio CLI (am) installer for Linux and macOS.
#
#   curl -fsSL https://cli.amplitudeaudiosdk.com/install.sh | sh                      # latest release
#   curl -fsSL https://cli.amplitudeaudiosdk.com/install.sh | sh -s -- --beta         # latest prerelease
#   curl -fsSL https://cli.amplitudeaudiosdk.com/install.sh | sh -s -- --nightly      # latest CI build of main
#
# Options:
#   --beta       Install the newest prerelease (alpha, beta or rc)
#   --nightly    Install the latest nightly build (CI artifact of the main branch)
#   -h, --help   Show this help
#
# Environment variables:
#   AM_VERSION       Install an exact release, e.g. 0.1.0 or v0.1.0
#   AM_CHANNEL       stable (default), beta or nightly; the flags above take precedence
#   AM_INSTALL_DIR   Where to put the `am` binary (default: $HOME/.amplitude/bin)
#   AM_REPO          GitHub repository to download from (default: AmplitudeAudio/cli)
#   AM_NIGHTLY_BASE  Base URL of the nightly artifacts
#                    (default: https://nightly.link/<repo>/workflows/nightly/main)

set -eu

REPO="${AM_REPO:-AmplitudeAudio/cli}"
INSTALL_DIR="${AM_INSTALL_DIR:-$HOME/.amplitude/bin}"
COMPLETIONS_DIR="${AM_COMPLETIONS_DIR:-$(dirname "$INSTALL_DIR")/completions}"
GITHUB="https://github.com/$REPO"
NIGHTLY_BASE="${AM_NIGHTLY_BASE:-https://nightly.link/$REPO/workflows/nightly/main}"
CHANNEL="${AM_CHANNEL:-stable}"

if [ -t 1 ]; then
  BOLD="$(printf '\033[1m')"; RED="$(printf '\033[31m')"
  GREEN="$(printf '\033[32m')"; DIM="$(printf '\033[2m')"; RESET="$(printf '\033[0m')"
else
  BOLD=""; RED=""; GREEN=""; DIM=""; RESET=""
fi

info() { printf '%s\n' "$*"; }
ok()   { printf '%s✓%s %s\n' "$GREEN" "$RESET" "$*"; }
fail() { printf '%serror:%s %s\n' "$RED" "$RESET" "$*" >&2; exit 1; }

usage() {
  cat <<'EOF'
Amplitude Audio CLI installer

Usage: install.sh [--beta | --nightly]

  (no option)  Install the latest stable release
  --beta       Install the newest prerelease (alpha, beta or rc)
  --nightly    Install the latest nightly build (CI artifact of main)
  -h, --help   Show this help

Environment: AM_VERSION, AM_CHANNEL, AM_INSTALL_DIR, AM_REPO, AM_NIGHTLY_BASE
EOF
}

parse_args() {
  for arg in "$@"; do
    case "$arg" in
      --beta)    CHANNEL="beta" ;;
      --nightly) CHANNEL="nightly" ;;
      -h|--help) usage; exit 0 ;;
      *) fail "Unknown option: $arg (try --help)" ;;
    esac
  done

  case "$CHANNEL" in
    stable|beta|nightly) ;;
    *) fail "Unknown channel '$CHANNEL'. Use stable, beta or nightly." ;;
  esac
  if [ -n "${AM_VERSION:-}" ] && [ "$CHANNEL" != "stable" ]; then
    fail "AM_VERSION cannot be combined with the $CHANNEL channel."
  fi
}

need() {
  command -v "$1" >/dev/null 2>&1 || fail "'$1' is required but was not found in PATH."
}

fetch() {
  # fetch <url> <output file>
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL --retry 3 -o "$2" "$1"
  elif command -v wget >/dev/null 2>&1; then
    wget -q -O "$2" "$1"
  else
    fail "curl or wget is required to download files."
  fi
}

detect_target() {
  os="$(uname -s)"
  arch="$(uname -m)"

  case "$os" in
    Linux)
      case "$arch" in
        x86_64|amd64)  echo "x86_64-unknown-linux-gnu" ;;
        aarch64|arm64) echo "aarch64-unknown-linux-gnu" ;;
        *) fail "Unsupported Linux architecture: $arch" ;;
      esac
      ;;
    Darwin)
      # A shell running under Rosetta reports x86_64 on Apple Silicon.
      if [ "$arch" = "x86_64" ] && [ "$(sysctl -n hw.optional.arm64 2>/dev/null || echo 0)" = "1" ]; then
        arch="arm64"
      fi
      case "$arch" in
        x86_64)        echo "x86_64-apple-darwin" ;;
        arm64|aarch64) echo "aarch64-apple-darwin" ;;
        *) fail "Unsupported macOS architecture: $arch" ;;
      esac
      ;;
    *)
      fail "Unsupported operating system: $os. On Windows, use install.ps1 instead."
      ;;
  esac
}

release_tags() {
  # Newest-first release tags from the releases feed (prereleases included).
  feed="$(mktemp)"
  if fetch "$GITHUB/releases.atom" "$feed" 2>/dev/null; then
    sed -n 's|.*<link[^>]*href="[^"]*/releases/tag/\([^"]*\)".*|\1|p' "$feed"
  fi
  rm -f "$feed"
}

latest_stable() {
  tag=""

  # Preferred: /releases/latest redirects to /releases/tag/<tag> (stable releases only).
  if command -v curl >/dev/null 2>&1; then
    url="$(curl -fsSL -o /dev/null -w '%{url_effective}' "$GITHUB/releases/latest" 2>/dev/null || true)"
    tag="${url##*/}"
  fi

  # Fallback: the newest non-prerelease tag in the releases feed.
  case "$tag" in
    v[0-9]*) ;;
    *) tag="$(release_tags | grep -Ev -- '-(alpha|beta|rc)' | head -n 1 || true)" ;;
  esac

  case "$tag" in
    v[0-9]*) echo "${tag#v}" ;;
    *) fail "No published release found at $GITHUB/releases." ;;
  esac
}

latest_beta() {
  tag="$(release_tags | grep -E -- '^v[0-9].*-(alpha|beta|rc)' | head -n 1 || true)"
  [ -n "$tag" ] || fail "No prerelease (alpha, beta or rc) found at $GITHUB/releases."
  echo "${tag#v}"
}

sha256_of() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | cut -d ' ' -f 1
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | cut -d ' ' -f 1
  else
    fail "sha256sum or shasum is required to verify the download."
  fi
}

verify_checksum() {
  # verify_checksum <archive> <checksum file>
  expected="$(cut -d ' ' -f 1 "$2" | tr 'A-F' 'a-f')"
  actual="$(sha256_of "$1")"
  [ -n "$expected" ] && [ "$expected" = "$actual" ] \
    || fail "Checksum mismatch for $(basename "$1") (expected $expected, got $actual)."
  ok "Checksum verified"
}

download_release() {
  # download_release <version> <target> <tmp dir>; leaves the extracted files in <tmp dir>/extract
  version="$1"; target="$2"; tmp="$3"
  archive="am-v${version}-${target}.zip"
  base_url="$GITHUB/releases/download/v${version}"

  fetch "$base_url/$archive" "$tmp/$archive" \
    || fail "Download failed: $base_url/$archive
       Release v${version} may not be published yet, or has no build for ${target}. See $GITHUB/releases"
  fetch "$base_url/$archive.sha256" "$tmp/$archive.sha256" \
    || fail "Download failed: $base_url/$archive.sha256"

  verify_checksum "$tmp/$archive" "$tmp/$archive.sha256"
  unzip -q -o "$tmp/$archive" -d "$tmp/extract" || fail "Could not extract $archive."
}

download_nightly() {
  # download_nightly <target> <tmp dir>; leaves the extracted files in <tmp dir>/extract
  target="$1"; tmp="$2"
  artifact="am-nightly-${target}"
  url="$NIGHTLY_BASE/$artifact.zip"

  fetch "$url" "$tmp/outer.zip" \
    || fail "Download failed: $url
       No nightly build is available for ${target} yet. Use the default channel or --beta instead."
  unzip -q -o "$tmp/outer.zip" -d "$tmp/outer" || fail "Could not extract the nightly artifact."

  # CI artifacts hold the release-style archive (and its checksum) inside the outer zip.
  if [ -f "$tmp/outer/$artifact.zip" ]; then
    if [ -f "$tmp/outer/$artifact.zip.sha256" ]; then
      verify_checksum "$tmp/outer/$artifact.zip" "$tmp/outer/$artifact.zip.sha256"
    fi
    unzip -q -o "$tmp/outer/$artifact.zip" -d "$tmp/extract" || fail "Could not extract $artifact.zip."
  else
    mv "$tmp/outer" "$tmp/extract"
  fi
}

main() {
  parse_args "$@"
  need uname
  need unzip
  need mktemp
  need find

  target="$(detect_target)"
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT INT TERM

  case "$CHANNEL" in
    nightly)
      label="nightly"
      info "${BOLD}Installing Amplitude CLI nightly${RESET} ${DIM}(${target})${RESET}"
      download_nightly "$target" "$tmp"
      ;;
    *)
      version="${AM_VERSION:-}"
      if [ -z "$version" ]; then
        info "Looking up the latest ${CHANNEL} release..."
        if [ "$CHANNEL" = "beta" ]; then version="$(latest_beta)"; else version="$(latest_stable)"; fi
      fi
      version="${version#v}"
      label="v${version}"
      info "${BOLD}Installing Amplitude CLI v${version}${RESET} ${DIM}(${target})${RESET}"
      download_release "$version" "$target" "$tmp"
      ;;
  esac

  bin="$(find "$tmp/extract" -type f -name am | head -n 1)"
  [ -n "$bin" ] || fail "The archive does not contain the 'am' binary."

  mkdir -p "$INSTALL_DIR"
  cp "$bin" "$INSTALL_DIR/am.new"
  chmod +x "$INSTALL_DIR/am.new"
  mv -f "$INSTALL_DIR/am.new" "$INSTALL_DIR/am"
  ok "Installed am ${label} to $INSTALL_DIR/am"

  completions="$(dirname "$bin")/completions"
  if [ -d "$completions" ]; then
    mkdir -p "$COMPLETIONS_DIR"
    cp "$completions/"* "$COMPLETIONS_DIR/"
    ok "Shell completions copied to $COMPLETIONS_DIR"
  fi

  case ":$PATH:" in
    *":$INSTALL_DIR:"*)
      info ""
      info "Run ${BOLD}am --help${RESET} to get started."
      ;;
    *)
      info ""
      info "${BOLD}$INSTALL_DIR${RESET} is not in your PATH. Add it with:"
      info ""
      info "  echo 'export PATH=\"$INSTALL_DIR:\$PATH\"' >> ~/.profile"
      info ""
      info "then restart your shell and run ${BOLD}am --help${RESET}."
      ;;
  esac
}

main "$@"
