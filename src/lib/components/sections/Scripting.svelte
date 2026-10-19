<script lang="ts">
	import CodeWindow from '#lib/components/CodeWindow.svelte';
	import Terminal from '#lib/components/Terminal.svelte';
	import Rich from '#lib/components/Rich.svelte';
	import { scriptSession } from '#lib/data/site.js';
	import { m } from '#lib/paraglide/messages.js';

	const bullets = [m.scr_b1(), m.scr_b2(), m.scr_b3(), m.scr_b4()];
</script>

<section id="scripting" class="border-t border-line bg-surface">
	<div class="mx-auto flex max-w-6xl flex-wrap items-center gap-12 px-8 py-24">
		<div class="flex min-w-0 flex-[1_1_400px] flex-col gap-5">
			<span class="eyebrow">{m.scr_eyebrow()}</span>
			<h2 class="m-0 font-mono text-4xl leading-[1.15] font-bold tracking-[-0.02em] text-white">
				{m.scr_title()}
			</h2>
			<p class="m-0 text-lg leading-relaxed text-muted">
				<Rich text={m.scr_lead()} codeClass="inline-code text-[15px]" />
			</p>
			<ul class="m-0 flex list-none flex-col gap-3 p-0 text-base leading-relaxed text-fg">
				{#each bullets as item (item)}
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
							class="mt-[3px] shrink-0 text-accent"><path d="M5 12.5l4.5 4.5L19 7.5" /></svg
						>
						<span><Rich text={item} codeClass="font-mono text-sm text-code" /></span>
					</li>
				{/each}
			</ul>
		</div>

		<CodeWindow title={m.scr_window()} class="flex-[1_1_480px]">
			<Terminal lines={scriptSession()} label={m.scr_aria()} />
		</CodeWindow>
	</div>
</section>
