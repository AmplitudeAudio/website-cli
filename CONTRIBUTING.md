# Contributing

Thanks for your interest in improving the Amplitude CLI website. This guide explains how to set the project up and what
we look for in a change.

By taking part, you agree to follow the [Code of Conduct](https://github.com/AmplitudeAudio/cli/blob/main/CODE_OF_CONDUCT.md)
used across the Amplitude projects.

## Reporting Issues

Before opening an issue, check that it isn't already reported. A useful report includes:

- what you expected, and what happened instead;
- the page and language (for example `/fr`) where you saw it;
- your browser and operating system;
- a screenshot, for visual problems.

Problems with the CLI itself, rather than its website, belong in the
[CLI repository](https://github.com/AmplitudeAudio/cli/issues).

## Setting Up

You need [Bun](https://bun.sh).

```sh
bun install
bun run dev
```

Before sending a change, make sure the site still builds and type-checks:

```sh
bun run build
bun run check
```

`bun run check` currently reports one error from the generated `src/lib/paraglide/` folder. Your change should not add
any new ones.

## Making A Change

1. Fork the repository and create a branch from `main`.
2. Make your change, keeping it focused on one thing.
3. Check the page in a browser, at desktop and phone widths, and in more than one language when you touched text.
4. Open a pull request that explains what changed and why. Add a screenshot for visual changes.

### Commit Messages

Use the `<type>: <description>` format, with an optional body:

```text
feat: add a language dropdown to the header
fix: keep anchor links below the sticky header
```

Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `ci`.

## Guidelines

### Text And Translations

- Never hardcode visible text in a component. Add a message to **all four** files in `messages/` (`en`, `fr`, `ja`, `zh`)
  with the same key, and read it with `m.your_key()`.
- Mark inline code in a message with backticks and render it with the `Rich` component.
- Leave commands, flags, file names and brand names untranslated.
- Resolve messages while rendering, in a component or in a function. A constant evaluated at module level is computed once
  and would show the same language on every prerendered page.
- A machine translation is a fine starting point, but ask a native speaker to review it when you can.

### Components And Styling

- Use Svelte 5 runes (`$state`, `$derived`, `$props`). The project forces runes mode.
- Style with Tailwind utility classes and the design tokens in `src/routes/layout.css` (`bg-surface`, `text-accent`, and
  so on) instead of raw colour values.
- Keep components small and focused. Home page sections live in `src/lib/components/sections/`.
- Links to other pages must go through `resolve()` and `asset()` from `$app/paths`, so they work on the static host.
- Keep the page accessible: real `<button>` and `<a>` elements, labels on icon-only controls, a visible focus outline,
  touch targets of at least 44px, and text that meets contrast requirements.

### Install Scripts

`static/install.sh` and `static/install.ps1` are served as-is at `/install.sh` and `/install.ps1`. When you edit them:

- keep the two scripts equivalent in behaviour and options;
- keep `install.sh` POSIX `sh` and lint it with `shellcheck`;
- stay in step with the asset names published by the CLI's release and nightly workflows;
- never weaken the checksum verification.

### Static Hosting

The site is deployed to GitHub Pages as plain static files, so there is no server code. The locale comes from the URL
(`/fr`, `/ja`, `/zh`), and unknown paths are served by `404.html`.

## License

By contributing, you agree that your contributions are licensed under the [Apache License 2.0](LICENSE).
