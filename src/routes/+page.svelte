<script lang="ts">
	import Commands from '#lib/components/sections/Commands.svelte';
	import Family from '#lib/components/sections/Family.svelte';
	import Hero from '#lib/components/sections/Hero.svelte';
	import Install from '#lib/components/sections/Install.svelte';
	import Roadmap from '#lib/components/sections/Roadmap.svelte';
	import Scripting from '#lib/components/sections/Scripting.svelte';
	import Workflow from '#lib/components/sections/Workflow.svelte';
	import SiteFooter from '#lib/components/SiteFooter.svelte';
	import SiteHeader from '#lib/components/SiteHeader.svelte';
	import { m } from '#lib/paraglide/messages.js';
</script>

<svelte:head>
	<title>{m.page_title()}</title>
	<meta
		name="description"
		content={m.page_description()}
	/>
</svelte:head>

<SiteHeader />
<main>
	<Hero />
	<Workflow />
	<Commands />
	<Scripting />
	<Roadmap />
	<Install />
	<Family />
</main>
<SiteFooter />
