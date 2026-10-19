<script lang="ts">
	import CodeWindow from '#lib/components/CodeWindow.svelte';
	import InstallCommand from '#lib/components/InstallCommand.svelte';
	import SectionHeading from '#lib/components/SectionHeading.svelte';
	import Terminal from '#lib/components/Terminal.svelte';
	import Rich from '#lib/components/Rich.svelte';
	import { GITHUB_URL, INSTALL_COMMANDS, SITE_URL, sourceSession } from '#lib/data/site.js';
	import { m } from '#lib/paraglide/messages.js';

	const targets = ['Linux · x86_64, aarch64', 'macOS · Intel, Apple Silicon', 'Windows · x86_64'];
</script>

<section id="install" class="border-t border-line bg-surface">
	<div class="mx-auto flex max-w-6xl flex-col gap-10 px-8 py-24">
		<SectionHeading eyebrow={m.inst_eyebrow()}>
			{#snippet title()}<Rich text={m.inst_title()} codeClass="font-mono text-[length:inherit] text-accent-soft" />{/snippet}
			{#snippet lead()}{m.inst_lead()}{/snippet}
		</SectionHeading>

		<div class="flex flex-wrap items-stretch gap-5">
			<div class="flex min-w-0 flex-[1_1_100%] flex-col gap-5 rounded-[2px] border border-accent bg-bg p-7">
				<div class="flex flex-wrap items-center justify-between gap-x-4 gap-y-2">
					<h3 class="m-0 font-mono text-2xl leading-snug font-semibold tracking-[-0.01em] text-white">
						{m.inst_script_title()}
					</h3>
					<span
						class="rounded-[2px] bg-accent px-2 py-[3px] font-mono text-xs font-semibold tracking-[0.06em] text-bg"
						>{m.inst_fastest()}</span
					>
				</div>
				<p class="m-0 text-base leading-relaxed text-fg">
					{m.inst_script_text()}
					<a href="{SITE_URL}/install.sh">install.sh</a> · <a href="{SITE_URL}/install.ps1">install.ps1</a>
				</p>
				<div class="flex flex-wrap gap-4">
					<CodeWindow title="LINUX · MACOS" class="flex-[1_1_420px]">
						<InstallCommand prompt={INSTALL_COMMANDS.unix.prompt} command={INSTALL_COMMANDS.unix.command} />
					</CodeWindow>
					<CodeWindow title="WINDOWS · POWERSHELL" class="flex-[1_1_420px]">
						<InstallCommand
							prompt={INSTALL_COMMANDS.windows.prompt}
							command={INSTALL_COMMANDS.windows.command}
						/>
					</CodeWindow>
				</div>
			</div>

			<div class="flex min-w-0 flex-[1_1_340px] flex-col gap-[18px] rounded-[2px] border border-line bg-bg p-7">
				<h3 class="m-0 font-mono text-2xl leading-snug font-semibold tracking-[-0.01em] text-white">
					{m.inst_bin_title()}
				</h3>
				<p class="m-0 text-base leading-relaxed text-fg">{m.inst_bin_text()}</p>
				<ul class="m-0 flex list-none flex-col gap-2 p-0 font-mono text-sm text-fg">
					{#each targets as target (target)}
						<li class="border-t border-line pt-2">{target}</li>
					{/each}
				</ul>
				<p class="m-0 grow text-[15px] leading-relaxed text-muted">
					<Rich text={m.inst_bin_detail()} codeClass="font-mono text-[13px] text-code" />
				</p>
				<div>
					<a href="{GITHUB_URL}/releases" class="btn btn-primary min-h-12 px-6 text-[15px] hover:no-underline">
						{m.inst_download()}
					</a>
				</div>
			</div>

			<CodeWindow title={m.inst_source_title()} rounded={false} class="flex-[1_1_480px]">
				<Terminal lines={sourceSession()} label={m.inst_source_aria()} />
			</CodeWindow>
		</div>
	</div>
</section>
