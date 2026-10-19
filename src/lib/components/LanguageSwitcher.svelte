<script lang="ts">
	import type { Path } from '$app/types';
	import { resolve } from '$app/paths';
	import { page } from '$app/state';
	import { m } from '#lib/paraglide/messages.js';
	import { getLocale, localizeHref, locales } from '#lib/paraglide/runtime.js';

	const names: Record<string, string> = {
		en: 'English',
		fr: 'Français',
		ja: '日本語',
		zh: '中文'
	};

	const current = getLocale();
	let menu = $state<HTMLDetailsElement>();

	// Pages serves /fr from fr.html, but not /fr/.
	const hrefFor = (locale: (typeof locales)[number]) =>
		localizeHref(page.url.pathname, { locale }).replace(/(.)\/$/, '$1');

	function closeOnOutsideClick(event: MouseEvent) {
		if (menu?.open && !menu.contains(event.target as Node)) menu.open = false;
	}

	function closeOnEscape(event: KeyboardEvent) {
		if (event.key !== 'Escape' || !menu?.open) return;
		menu.open = false;
		menu.querySelector('summary')?.focus();
	}
</script>

<svelte:window onclick={closeOnOutsideClick} onkeydown={closeOnEscape} />

<details bind:this={menu} class="relative">
	<summary
		aria-label={m.lang_aria()}
		class="flex min-h-11 cursor-pointer list-none items-center gap-2 rounded-[2px] border border-outline px-3 font-mono text-[13px] font-semibold text-fg transition-colors duration-150 marker:hidden hover:bg-surface hover:text-white [&::-webkit-details-marker]:hidden"
	>
		<svg
			aria-hidden="true"
			width="18"
			height="18"
			viewBox="0 0 24 24"
			fill="none"
			stroke="currentColor"
			stroke-width="1.75"
			stroke-linecap="round"
			stroke-linejoin="round"
		>
			<circle cx="12" cy="12" r="9" />
			<path d="M3.6 9h16.8M3.6 15h16.8M12 3a14 14 0 0 1 0 18M12 3a14 14 0 0 0 0 18" />
		</svg>
		<span>{names[current]}</span>
	</summary>
	<ul
		class="absolute top-[calc(100%+8px)] right-0 z-40 m-0 min-w-40 list-none rounded-[2px] border border-line bg-surface p-1.5 shadow-[0_12px_32px_rgba(0,0,0,0.4)]"
	>
		{#each locales as locale (locale)}
			<li>
				<!-- A full reload re-evaluates every message in the new locale. -->
				<a
					href={resolve(hrefFor(locale) as Path)}
					hreflang={locale}
					lang={locale}
					aria-current={locale === current ? 'true' : undefined}
					data-sveltekit-reload
					class="block rounded-[2px] px-3 py-2 font-mono text-[13px] hover:bg-line hover:text-white hover:no-underline {locale ===
					current
						? 'font-bold text-accent-soft'
						: 'text-fg'}">{names[locale]}</a
				>
			</li>
		{/each}
	</ul>
</details>
