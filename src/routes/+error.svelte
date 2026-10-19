<script lang="ts">
	import { resolve } from '$app/paths';
	import { page } from '$app/state';
	import type { Path } from '$app/types';
	import SiteFooter from '#lib/components/SiteFooter.svelte';
	import SiteHeader from '#lib/components/SiteHeader.svelte';
	import { m } from '#lib/paraglide/messages.js';
	import { localizeHref } from '#lib/paraglide/runtime.js';

	const notFound = $derived(page.status === 404);
	const title = $derived(notFound ? m.notfound_title() : m.error_title());
	const home = $derived(resolve(localizeHref('/') as Path));
</script>

<svelte:head>
	<title>{title} · Amplitude CLI</title>
</svelte:head>

<SiteHeader homeHref={home} />
<main
	class="mx-auto flex min-h-[60vh] max-w-6xl flex-col items-center justify-center gap-5 px-8 py-28 text-center"
>
	<span class="font-mono text-7xl leading-none font-semibold text-accent">{page.status}</span>
	<h1 class="m-0 font-mono text-4xl leading-[1.15] font-bold tracking-[-0.02em] text-white">{title}</h1>
	{#if notFound}
		<p class="m-0 max-w-xl text-lg leading-relaxed text-muted">{m.notfound_desc()}</p>
	{/if}
	<a href={home} class="btn btn-primary mt-2 min-h-12 px-6 text-[15px] hover:no-underline">
		{m.error_home()}
	</a>
</main>
<SiteFooter />
