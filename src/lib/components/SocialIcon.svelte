<script lang="ts" module>
	export type SocialIconName = 'github' | 'discord' | 'x';
</script>

<script lang="ts">
	let { name, size = 20 }: { name: SocialIconName; size?: number } = $props();
</script>

<svg
	aria-hidden="true"
	width={size}
	height={size}
	viewBox="0 0 24 24"
	fill="none"
	stroke="currentColor"
	stroke-width="1.75"
	stroke-linecap="round"
	stroke-linejoin="round"
>
	{#if name === 'github'}
		<path
			d="M9 19c-4.3 1.4-4.3-2.5-6-3m12 5v-3.5c0-1 .1-1.4-.5-2 2.8-.3 5.5-1.4 5.5-6a4.6 4.6 0 0 0-1.3-3.2 4.2 4.2 0 0 0-.1-3.2s-1.1-.3-3.5 1.3a12.3 12.3 0 0 0-6.2 0C6.5 2.8 5.4 3.1 5.4 3.1a4.2 4.2 0 0 0-.1 3.2A4.6 4.6 0 0 0 4 9.5c0 4.6 2.7 5.7 5.5 6-.6.6-.6 1.2-.5 2V21"
		/>
	{:else if name === 'discord'}
		<path d="M8 12a1 1 0 1 0 2 0 1 1 0 0 0-2 0M14 12a1 1 0 1 0 2 0 1 1 0 0 0-2 0" />
		<path
			d="M8.5 17c0 1-1.356 3-1.832 3-1.429 0-2.698-1.667-3.333-3-.635-1.667-.476-5.833 1.428-11.5 1.388-1.015 2.782-1.34 4.237-1.5l.975 1.923a11.913 11.913 0 0 1 4.053 0l.972-1.923c1.5.16 3.043.485 4.5 1.5 2 5.667 2.167 9.833 1.5 11.5-.667 1.333-2 3-3.5 3-.5 0-2-2-2-3"
		/>
		<path d="M7 16.5c3.5 1 6.5 1 10 0" />
	{:else if name === 'x'}
		<path d="M4 4l11.733 16h4.267L8.267 4z" />
		<path d="M4 20l6.768-6.768m2.46-2.46L20 4" />
	{/if}
</svg>
