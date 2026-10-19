<script lang="ts">
	import type { Snippet } from 'svelte';

	let {
		eyebrow,
		lead,
		title,
		children
	}: {
		eyebrow: string;
		lead?: Snippet;
		title: Snippet;
		children?: Snippet;
	} = $props();
</script>

<div class="flex max-w-3xl flex-col gap-3">
	<span class="eyebrow">{eyebrow}</span>
	<h2 class="m-0 font-mono text-4xl leading-[1.15] font-bold tracking-[-0.02em] text-white">
		{@render title()}
	</h2>
	{#if lead}
		<p class="m-0 text-lg leading-relaxed text-muted">{@render lead()}</p>
	{/if}
	{@render children?.()}
</div>
