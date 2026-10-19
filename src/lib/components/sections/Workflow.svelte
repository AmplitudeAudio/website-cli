<script lang="ts">
	import SectionHeading from '#lib/components/SectionHeading.svelte';
	import { workflowSteps } from '#lib/data/commands.js';
	import { m } from '#lib/paraglide/messages.js';
</script>

<section id="workflow" class="border-t border-line bg-surface">
	<div class="mx-auto flex max-w-6xl flex-col gap-10 px-8 py-24">
		<SectionHeading eyebrow={m.wf_eyebrow()}>
			{#snippet title()}{m.wf_title()}{/snippet}
			{#snippet lead()}{m.wf_lead()}{/snippet}
		</SectionHeading>

		<div class="grid grid-cols-[repeat(auto-fit,minmax(250px,1fr))] gap-5">
			{#each workflowSteps() as step (step.step)}
				<div class="flex flex-col gap-3.5 rounded-[2px] border border-line bg-bg p-6">
					<span class="eyebrow">{step.step}</span>
					<h3 class="m-0 font-mono text-2xl leading-snug font-semibold tracking-[-0.01em] text-white">
						{step.title}
					</h3>
					<p class="m-0 grow text-base leading-relaxed text-fg">{step.body}</p>
					<code
						class="rounded-[2px] bg-term px-3 py-2.5 font-mono text-[13px] leading-relaxed [overflow-wrap:anywhere] text-code"
						>{step.cmd}</code
					>
				</div>
			{/each}
		</div>
	</div>
</section>
