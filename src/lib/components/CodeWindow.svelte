<script lang="ts">
	import type { Snippet } from 'svelte';

	let {
		title,
		meta,
		rounded = true,
		class: className = '',
		actions,
		children
	}: {
		title: string;
		meta?: string;
		rounded?: boolean;
		class?: string;
		actions?: Snippet;
		children: Snippet;
	} = $props();
</script>

<div
	class="flex min-w-0 flex-col overflow-hidden border border-line bg-term {rounded
		? 'rounded-lg'
		: 'rounded-[2px]'} {className}"
>
	<div
		class="flex flex-wrap items-center justify-between gap-2 border-b border-line font-mono text-xs font-semibold tracking-[0.06em] text-muted {actions
			? 'py-2 pr-2 pl-4'
			: 'px-4 py-2.5'}"
	>
		<span>{title}</span>
		{#if meta}<span>{meta}</span>{/if}
		{@render actions?.()}
	</div>
	{@render children()}
</div>
