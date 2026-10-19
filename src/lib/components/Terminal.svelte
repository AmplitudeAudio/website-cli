<script lang="ts">
	import type { TerminalLine } from '#lib/data/site.js';

	let { lines, label }: { lines: TerminalLine[]; label: string } = $props();
</script>

<!-- Focusable so keyboard users can scroll a horizontally overflowing block. -->
<!-- svelte-ignore a11y_no_noninteractive_tabindex -->
<pre
	tabindex="0"
	aria-label={label}
	class="m-0 grow overflow-x-auto px-4 py-5 font-mono text-[13px] leading-[1.8] text-code">{#each lines as line, i (i)}{#if line.kind === 'comment'}<span class="text-muted">{line.text}</span>{:else if line.kind === 'cmd'}<span class="text-accent">$</span> {line.text}{:else if line.kind === 'plain'}{line.text}{/if}
{/each}</pre>
