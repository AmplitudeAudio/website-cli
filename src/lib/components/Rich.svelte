<script lang="ts">
	// Renders a message where `backtick` spans are inline code. The markers keep
	// word order up to the translator, and no HTML is ever injected.
	let { text, codeClass = 'inline-code' }: { text: string; codeClass?: string } = $props();

	const parts = $derived(text.split('`'));
</script>

{#each parts as part, i (i)}{#if i % 2 === 1}<code class={codeClass}>{part}</code>{:else}{part}{/if}{/each}
