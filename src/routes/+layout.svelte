<script lang="ts">
	import type { Path } from '$app/types';
	import { asset, resolve } from '$app/paths';
	import { page } from '$app/state';
	import { locales, localizeHref } from '#lib/paraglide/runtime.js';
	import './layout.css';
	import type { LayoutProps } from './$types';

	let { children }: LayoutProps = $props();
</script>

<svelte:head>
	<link rel="icon" href={asset('images/icon_cli.svg')} type="image/svg+xml" />
</svelte:head>

{@render children()}

<div style="display:none">
	{#each locales as locale (locale)}
		<a
			href={resolve(localizeHref(page.url.pathname, { locale }) as Path)}
		>{locale}</a>
	{/each}
</div>
