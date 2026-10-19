<script lang="ts">
	import { onDestroy } from 'svelte';
	import { m } from '#lib/paraglide/messages.js';

	let { text }: { text: string } = $props();

	let copied = $state(false);
	let timer: ReturnType<typeof setTimeout> | undefined;

	async function copy() {
		try {
			await navigator.clipboard.writeText(text);
		} catch {
			return;
		}
		copied = true;
		clearTimeout(timer);
		timer = setTimeout(() => (copied = false), 1800);
	}

	onDestroy(() => clearTimeout(timer));
</script>

<button type="button" class="btn btn-primary min-w-[84px] shrink-0 justify-center text-[13px]" onclick={copy}>
	{copied ? m.common_copied() : m.common_copy()}
	<span class="sr-only" aria-live="polite">{copied ? m.common_copied_sr() : ''}</span>
</button>
