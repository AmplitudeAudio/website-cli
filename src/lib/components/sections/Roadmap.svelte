<script lang="ts">
	import SectionHeading from '#lib/components/SectionHeading.svelte';
	import { m } from '#lib/paraglide/messages.js';

	const available = [m.road_i1(), m.road_i2(), m.road_i3(), m.road_i4(), m.road_i5()];
</script>

<section id="roadmap" class="mx-auto flex max-w-6xl flex-col gap-10 px-8 py-24">
	<SectionHeading eyebrow={m.road_eyebrow()}>
		{#snippet title()}{m.road_title()}{/snippet}
		{#snippet lead()}{m.road_lead()}{/snippet}
	</SectionHeading>

	<div class="flex flex-wrap gap-5">
		<div class="flex min-w-0 flex-[1_1_340px] flex-col gap-4 rounded-[2px] border border-line bg-surface p-6">
			<div class="flex items-center justify-between gap-3">
				<h3 class="m-0 font-mono text-2xl leading-snug font-semibold tracking-[-0.01em] text-white">
					{m.road_c1_title()}
				</h3>
				<span
					class="rounded-[2px] bg-ok px-2 py-[3px] font-mono text-xs font-semibold tracking-[0.06em] text-bg"
					>{m.road_available()}</span
				>
			</div>
			<ul class="m-0 flex list-none flex-col gap-2.5 p-0 text-base leading-normal text-fg">
				{#each available as item (item)}
					<li class="flex items-start gap-3">
						<svg
							aria-hidden="true"
							width="20"
							height="20"
							viewBox="0 0 24 24"
							fill="none"
							stroke="currentColor"
							stroke-width="2"
							stroke-linecap="round"
							stroke-linejoin="round"
							class="mt-0.5 shrink-0 text-ok"><path d="M5 12.5l4.5 4.5L19 7.5" /></svg
						>
						<span>{item}</span>
					</li>
				{/each}
			</ul>
		</div>

		<div
			class="flex min-w-0 flex-[1_1_340px] flex-col gap-4 rounded-[2px] border border-dashed border-outline bg-surface p-6"
		>
			<div class="flex items-center justify-between gap-3">
				<h3 class="m-0 font-mono text-2xl leading-snug font-semibold tracking-[-0.01em] text-white">
					{m.road_c2_title()}
				</h3>
				<span
					class="rounded-[2px] border border-accent-soft px-2 py-0.5 font-mono text-xs font-semibold tracking-[0.06em] text-accent-soft"
					>{m.road_planned()}</span
				>
			</div>
			<p class="m-0 text-base leading-relaxed text-fg">
				{m.road_c2_body()}
			</p>
			<div
				role="img"
				aria-label={m.road_sketch_aria()}
				class="grid grid-cols-[1fr_1.4fr] grid-rows-[auto_auto] gap-2 rounded-[2px] bg-term p-3 font-mono text-xs leading-[1.7] text-code"
			>
				<div class="row-span-2 rounded-[2px] border border-outline px-2.5 py-2">
					<div class="tracking-[0.06em] text-muted">{m.road_assets()}</div>
					<div class="text-accent">› footstep</div>
					<div>explosion</div>
					<div>ambient</div>
					<div>play_music</div>
				</div>
				<div class="rounded-[2px] border border-outline px-2.5 py-2">
					<div class="tracking-[0.06em] text-muted">{m.road_inspector()}</div>
					<div>gain&nbsp;&nbsp;&nbsp;0.8</div>
					<div>loop&nbsp;&nbsp;&nbsp;on</div>
				</div>
				<div class="rounded-[2px] border border-outline px-2.5 py-2">
					<div class="tracking-[0.06em] text-muted">{m.road_validation()}</div>
					<div class="text-ok">{m.road_ready()}</div>
				</div>
			</div>
		</div>
	</div>
</section>
