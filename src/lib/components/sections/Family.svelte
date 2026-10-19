<script lang="ts">
	import { asset } from '$app/paths';
	import SectionHeading from '#lib/components/SectionHeading.svelte';
	import { SDK_URL, STUDIO_URL } from '#lib/data/site.js';
	import { m } from '#lib/paraglide/messages.js';

	const tiles = $derived([
		{
			href: SDK_URL,
			name: 'Amplitude Audio SDK',
			body: m.fam_sdk_body(),
			cta: m.fam_sdk_cta(),
			icon: 'images/amplitude-sdk.png'
		},
		{
			href: STUDIO_URL,
			name: 'Amplitude Studio',
			body: m.fam_studio_body(),
			cta: m.fam_studio_cta(),
			icon: 'images/amplitude-studio.png'
		}
	] as const);
</script>

<section id="family" class="mx-auto flex max-w-6xl flex-col gap-8 px-8 py-24">
	<SectionHeading eyebrow={m.fam_eyebrow()}>
		{#snippet title()}{m.fam_title()}{/snippet}
	</SectionHeading>

	<div class="grid grid-cols-[repeat(auto-fit,minmax(320px,1fr))] gap-5">
		{#each tiles as tile (tile.href)}
			<a
				href={tile.href}
				class="flex items-start gap-5 rounded-[2px] border border-line bg-surface p-6 text-fg transition-colors duration-150 hover:border-accent hover:no-underline"
			>
				<img src={asset(tile.icon)} alt="" width="48" height="48" class="block size-12 shrink-0" />
				<span class="flex flex-col gap-2">
					<span class="font-mono text-xl font-semibold text-white">{tile.name}</span>
					<span class="text-base leading-relaxed">{tile.body}</span>
					<span class="font-mono text-sm font-semibold text-accent">{tile.cta}</span>
				</span>
			</a>
		{/each}
	</div>
</section>
