<script lang="ts">
	import SectionHeading from '#lib/components/SectionHeading.svelte';
	import Rich from '#lib/components/Rich.svelte';
	import { commandGroups, GLOBAL_FLAGS } from '#lib/data/commands.js';
	import { m } from '#lib/paraglide/messages.js';

	const groups = commandGroups();
	let selectedId = $state(groups[0].id);
	const group = $derived(groups.find((g) => g.id === selectedId) ?? groups[0]);
</script>

<section id="commands" class="mx-auto flex max-w-6xl flex-col gap-8 px-8 py-24">
	<SectionHeading eyebrow={m.cmds_eyebrow()}>
		{#snippet title()}{m.cmds_title()}{/snippet}
		{#snippet lead()}<Rich text={m.cmds_lead()} codeClass="inline-code text-[15px]" />{/snippet}
	</SectionHeading>

	<div role="group" aria-label={m.cmds_groups_aria()} class="flex flex-wrap gap-2">
		{#each groups as g (g.id)}
			<button
				type="button"
				aria-pressed={selectedId === g.id}
				onclick={() => (selectedId = g.id)}
				class="min-h-11 cursor-pointer rounded-[2px] border px-[18px] font-mono text-sm font-semibold transition-colors duration-150 {selectedId ===
				g.id
					? 'border-accent bg-accent text-bg'
					: 'border-outline bg-transparent text-fg hover:bg-surface'}"
			>
				{g.label}
			</button>
		{/each}
	</div>

	<div class="overflow-hidden rounded-[2px] border border-line bg-bg">
		<div class="px-5 py-4 text-base leading-normal text-muted">{group.note}</div>
		<div class="flex flex-col">
			{#each group.rows as row (row.cmd)}
				<div
					class="flex flex-wrap gap-x-8 gap-y-1.5 border-t border-line px-5 py-4 transition-colors duration-150 hover:bg-surface"
				>
					<div class="flex min-w-0 flex-[1_1_320px] flex-col gap-1.5">
						<code class="font-mono text-sm font-semibold [overflow-wrap:anywhere] text-white">{row.cmd}</code>
						{#if row.flags}
							<span class="font-mono text-[13px] [overflow-wrap:anywhere] text-accent-soft">{row.flags}</span>
						{/if}
					</div>
					<p class="m-0 min-w-0 flex-[1_1_320px] text-base leading-relaxed text-fg">{row.desc}</p>
				</div>
			{/each}
		</div>
	</div>

	<div class="flex flex-wrap items-center gap-x-4 gap-y-2.5">
		<span class="font-mono text-[13px] font-semibold tracking-[0.06em] text-muted">{m.cmds_global_flags()}</span>
		{#each GLOBAL_FLAGS as flag (flag)}
			<code class="inline-code px-2 py-[3px] text-[13px]">{flag}</code>
		{/each}
	</div>
</section>
