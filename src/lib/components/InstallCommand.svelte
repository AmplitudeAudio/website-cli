<script lang="ts">
	import CopyButton from './CopyButton.svelte';

	let { prompt, command }: { prompt: string; command: string } = $props();
</script>

<div class="flex items-center gap-3 py-3 pr-3 pl-4">
	<!-- Focusable so keyboard users can scroll a long command. -->
	<!-- svelte-ignore a11y_no_noninteractive_tabindex -->
	<code
		tabindex="0"
		class="min-w-0 flex-auto overflow-x-auto font-mono text-[13px] leading-[1.8] whitespace-pre text-code"
		><span class="text-accent">{prompt}</span> {command}</code
	>
	<CopyButton text={command} />
</div>
