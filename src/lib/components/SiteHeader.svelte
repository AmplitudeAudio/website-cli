<script lang="ts">
	import { asset } from '$app/paths';
	import LanguageSwitcher from '#lib/components/LanguageSwitcher.svelte';
	import { DOCS_URL, GITHUB_URL } from '#lib/data/site.js';
	import { m } from '#lib/paraglide/messages.js';

	// Where the in-page anchors live: empty on the home page, the home URL elsewhere.
	let { homeHref = '' }: { homeHref?: string } = $props();

	const links = $derived([
		{ href: `${homeHref}#workflow`, label: m.nav_workflow() },
		{ href: `${homeHref}#commands`, label: m.nav_commands() },
		{ href: `${homeHref}#scripting`, label: m.nav_scripting() },
		{ href: `${homeHref}#roadmap`, label: m.nav_roadmap() },
		{ href: DOCS_URL, label: m.nav_docs() },
		{ href: GITHUB_URL, label: 'GitHub' }
	]);
</script>

<header class="sticky top-0 z-30 border-b border-line bg-bg/92 backdrop-blur-sm">
	<div
		aria-hidden="true"
		class="absolute inset-x-0 top-0 h-0.5 bg-gradient-to-r from-accent to-accent-deep"
	></div>
	<nav
		aria-label={m.nav_main_aria()}
		class="mx-auto flex max-w-6xl flex-wrap items-center gap-x-8 gap-y-3 px-8 py-[18px]"
	>
		<a href="{homeHref}#top" class="flex items-center no-underline">
			<img src={asset('images/icon_cli.svg')} alt="Amplitude CLI" width="40" height="40" class="block size-10" />
		</a>
		<div class="flex grow flex-wrap gap-x-6 gap-y-1 font-mono text-[13px] font-semibold">
			{#each links as link (link.href)}
				<a
					href={link.href}
					class="text-fg transition-colors duration-150 hover:text-white hover:no-underline">{link.label}</a
				>
			{/each}
		</div>
		<div class="flex items-center gap-3">
			<LanguageSwitcher />
			<a href="{homeHref}#install" class="btn btn-primary hover:no-underline">{m.nav_install()}</a>
		</div>
	</nav>
</header>
