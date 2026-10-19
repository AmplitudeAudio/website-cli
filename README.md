<p align="center">
  <a href="https://cli.amplitudeaudiosdk.com">
    <img src="static/images/icon_cli.svg" width="96" alt="Amplitude CLI">
  </a>
</p>

<div align="center">

# Amplitude CLI Website

The website of the [Amplitude CLI](https://github.com/AmplitudeAudio/cli), the official command-line tool to manage
your Amplitude projects. It presents the CLI, documents the commands you can run today, and hosts the scripts that
install it.

<br/>

[Visit the website](https://cli.amplitudeaudiosdk.com) | [CLI repository](https://github.com/AmplitudeAudio/cli) | [Documentation](https://docs.amplitudeaudiosdk.com)

<br/>
</div>

## What's In The Site

- A single page that walks through the CLI workflow: create a project, author assets, validate and build.
- A browsable reference of the available commands, grouped by topic.
- One-command install instructions for Linux, macOS and Windows.
- The install scripts themselves, served at [`/install.sh`](static/install.sh) and [`/install.ps1`](static/install.ps1).
- Four languages: English, French, Japanese and Chinese, each at its own URL (`/`, `/fr`, `/ja`, `/zh`).
- A custom 404 page and a sticky header with a language dropdown.

## Install Scripts

The CLI is installed with a single command:

```sh
# Linux and macOS
curl -fsSL https://cli.amplitudeaudiosdk.com/install.sh | bash
```

```powershell
# Windows (PowerShell)
powershell -NoProfile -Command "iex (irm 'https://cli.amplitudeaudiosdk.com/install.ps1')"
```

Both scripts download the release archive from the CLI's GitHub releases, verify its SHA-256 checksum, and install `am`
to `~/.amplitude/bin` along with the shell completions. They accept `--beta` / `--nightly` (`-Beta` / `-Nightly` on
Windows) and the `AM_VERSION`, `AM_INSTALL_DIR` and `AM_REPO` environment variables. See the header of each script for
the full list.

The scripts depend on the asset names published by the CLI's `release.yml` and `nightly.yml` workflows. If those change,
update the scripts in the same change.

## Tech Stack

- [SvelteKit](https://svelte.dev/docs/kit) with [Svelte 5](https://svelte.dev) (runes mode)
- [Tailwind CSS](https://tailwindcss.com) v4, with the design tokens defined in `src/routes/layout.css`
- [Paraglide](https://inlang.com/m/gerre34r/library-inlang-paraglideJs) for translations
- [`adapter-static`](https://svelte.dev/docs/kit/adapter-static), deployed to GitHub Pages
- [Bun](https://bun.sh) as the package manager

## Getting Started

You need [Bun](https://bun.sh) installed.

```sh
bun install
bun run dev
```

The site is then available at http://localhost:5173.

| Command             | Does                                                      |
|---------------------|-----------------------------------------------------------|
| `bun run dev`       | Start the development server                              |
| `bun run build`     | Build the static site into `build/`                       |
| `bun run preview`   | Preview the production build                              |
| `bun run check`     | Type-check the project with `svelte-check`                |

> `bun run check` currently reports one error coming from the generated `src/lib/paraglide/` folder. It is not caused by
> the site's own code.

## Project Structure

```text
messages/              Translations, one JSON file per language
src/
  lib/
    components/        Header, footer, language dropdown and shared pieces
      sections/        One component per section of the home page
    data/              Site links, install commands and the command reference
  routes/              The home page, the layout and the error page
static/
  install.sh           Install script for Linux and macOS
  install.ps1          Install script for Windows
  images/              Logos and icons
  CNAME                Custom domain for GitHub Pages
.github/workflows/     GitHub Pages deployment
```

## Translations

All visible text lives in `messages/{en,fr,ja,zh}.json`, and components read it with `m.some_key()`. Messages mark
inline code with backticks, which the `Rich` component renders as `<code>`. Commands, flags and brand names are not
translated.

The locale is taken from the URL (`/fr`, `/ja`, `/zh`), never from a cookie, so every language is prerendered as its own
static page.

## Deployment

Every push to `main` builds the site and publishes it to GitHub Pages through
[`.github/workflows/deploy.yml`](.github/workflows/deploy.yml). In the repository settings, set **Pages > Source** to
**GitHub Actions**. The custom domain is configured by `static/CNAME`.

## Contributing

Contributions are welcome. Please read the [contributing guide](CONTRIBUTING.md) first, and feel free to open an issue
if something looks wrong or could be better.

## License

This project is licensed under the [Apache License 2.0](LICENSE).
