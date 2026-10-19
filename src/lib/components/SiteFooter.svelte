<script lang="ts">
	import { asset } from '$app/paths';
	import SocialIcon, { type SocialIconName } from '#lib/components/SocialIcon.svelte';
	import { DISCORD_URL, DOCS_URL, GITHUB_URL, SDK_URL, STUDIO_URL, X_URL } from '#lib/data/site.js';
	import { m } from '#lib/paraglide/messages.js';

	const links = $derived([
		{ href: DOCS_URL, label: m.nav_docs() },
		{ href: SDK_URL, label: 'SDK' },
		{ href: STUDIO_URL, label: 'Studio' }
	]);

	const social: { href: string; label: string; icon: SocialIconName; size: number }[] = [
		{ href: DISCORD_URL, label: 'Discord', icon: 'discord', size: 20 },
		{ href: X_URL, label: 'X (formerly Twitter)', icon: 'x', size: 18 },
		{ href: GITHUB_URL, label: 'GitHub', icon: 'github', size: 20 }
	];
</script>

<footer class="border-t border-line">
	<div class="mx-auto flex max-w-6xl flex-wrap items-center justify-between gap-6 px-8 py-10">
		<div class="flex flex-col gap-2 text-sm text-muted">
			<img src={asset('images/amplitude-logo.svg')} alt="Amplitude" class="h-7 w-auto self-start" />
			<span>{m.foot_license()}</span>
			<span>{m.foot_copyright()}</span>
		</div>
		<div class="flex flex-col items-start gap-3.5 sm:items-end">
			<div class="flex flex-wrap gap-x-6 gap-y-2 font-mono text-[13px] font-semibold">
				{#each links as link (link.href)}
					<a href={link.href} class="text-fg hover:text-white hover:no-underline">{link.label}</a>
				{/each}
			</div>
			<ul class="m-0 flex list-none flex-wrap gap-2 p-0" aria-label={m.foot_social()}>
				{#each social as item (item.icon)}
					<li>
						<a
							href={item.href}
							aria-label={item.label}
							class="flex size-11 items-center justify-center rounded-full border border-outline text-fg transition-colors duration-150 hover:border-accent hover:text-white hover:no-underline"
						>
							<SocialIcon name={item.icon} size={item.size} />
						</a>
					</li>
				{/each}
			</ul>
		</div>
	</div>
</footer>
