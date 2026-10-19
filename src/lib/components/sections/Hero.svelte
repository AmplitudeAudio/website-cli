<script lang="ts">
	import { onMount } from 'svelte';
	import { m } from '#lib/paraglide/messages.js';
	import CodeWindow from '#lib/components/CodeWindow.svelte';
	import InstallCommand from '#lib/components/InstallCommand.svelte';
	import Terminal from '#lib/components/Terminal.svelte';
	import { demoSession, GITHUB_URL, INSTALL_COMMANDS, SITE_URL, type Os } from '#lib/data/site.js';

	const tabs: { id: Os; label: string }[] = [
		{ id: 'unix', label: 'Linux · macOS' },
		{ id: 'windows', label: 'Windows' }
	];

	let os = $state<Os>('unix');
	const install = $derived(INSTALL_COMMANDS[os]);

	onMount(() => {
		const platform =
			(navigator as Navigator & { userAgentData?: { platform?: string } }).userAgentData?.platform ??
			navigator.platform ??
			'';
		if (/win/i.test(platform)) os = 'windows';
	});
</script>

<section id="top" class="mx-auto flex max-w-6xl flex-wrap items-center gap-12 px-8 pt-24 pb-[88px]">
	<div class="flex min-w-0 flex-[1_1_420px] flex-col gap-6">
		<div
			class="inline-flex items-center gap-2.5 self-start rounded-[2px] border border-line bg-surface px-3 py-1.5 font-mono text-[13px] font-semibold tracking-[0.06em] text-fg"
		>
			<span aria-hidden="true" class="size-2 rounded-[2px] bg-accent"></span>
			{m.hero_badge()}
		</div>
		<h1
			class="m-0 font-mono text-[clamp(34px,4.4vw,52px)] leading-[1.05] font-bold tracking-[-0.02em] text-white"
		>
			{m.hero_title()}
		</h1>
		<p class="m-0 text-xl leading-relaxed text-fg">
			{m.hero_lead()}
		</p>

		<CodeWindow title={m.hero_install_title()}>
			{#snippet actions()}
				<div role="group" aria-label={m.hero_os_aria()} class="flex gap-1">
					{#each tabs as tab (tab.id)}
						<button
							type="button"
							aria-pressed={os === tab.id}
							onclick={() => (os = tab.id)}
							class="min-h-11 cursor-pointer rounded-[2px] border px-3.5 font-mono text-[13px] font-semibold tracking-normal transition-colors duration-150 {os ===
							tab.id
								? 'border-accent bg-accent text-bg'
								: 'border-outline bg-transparent text-fg hover:bg-surface'}"
						>
							{tab.label}
						</button>
					{/each}
				</div>
			{/snippet}
			<InstallCommand prompt={install.prompt} command={install.command} />
			<div class="border-t border-line px-4 py-2.5 text-[13px] leading-normal text-muted">
				{m.hero_read_script()}
				<a href="{SITE_URL}/install.sh">install.sh</a> · <a href="{SITE_URL}/install.ps1">install.ps1</a>
			</div>
		</CodeWindow>

		<div class="mt-1 flex flex-wrap items-center gap-x-4 gap-y-3">
			<a href={GITHUB_URL} class="btn btn-secondary min-h-12 px-6 text-[15px] hover:no-underline">
				{m.hero_github()}
			</a>
		</div>
		<p class="m-0 text-sm leading-normal text-muted">
			{m.hero_early()}
		</p>
	</div>

	<CodeWindow title={m.hero_terminal()} meta="AM 0.1.0" class="flex-[1_1_480px]">
		<Terminal lines={demoSession()} label={m.hero_terminal_aria()} />
	</CodeWindow>
</section>
