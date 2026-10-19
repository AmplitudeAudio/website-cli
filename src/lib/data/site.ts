import { m } from '#lib/paraglide/messages.js';

export const SITE_URL = 'https://cli.amplitudeaudiosdk.com';
export const GITHUB_URL = 'https://github.com/AmplitudeAudio/cli';
export const DOCS_URL = 'https://docs.amplitudeaudiosdk.com';
export const SDK_URL = 'https://amplitudeaudiosdk.com';
export const STUDIO_URL = 'https://studio.amplitudeaudiosdk.com';
export const DISCORD_URL = 'https://discord.gg/QR2uBpzJ5f';
export const X_URL = 'https://x.com/@amaudiosdk';

export type Os = 'unix' | 'windows';

export const INSTALL_COMMANDS: Record<Os, { prompt: string; command: string }> = {
	unix: { prompt: '$', command: `curl -fsSL ${SITE_URL}/install.sh | bash` },
	windows: {
		prompt: 'PS>',
		command: `powershell -NoProfile -Command "iex (irm '${SITE_URL}/install.ps1')"`
	}
};

export type TerminalLine =
	| { kind: 'comment' | 'cmd' | 'plain'; text: string }
	| { kind: 'blank' };

// Functions, not constants: comments are translated, so they must resolve per request.
export const demoSession = (): TerminalLine[] => [
	{ kind: 'comment', text: m.demo_c1() },
	{ kind: 'cmd', text: 'am project init my_game' },
	{ kind: 'cmd', text: 'cd my_game' },
	{ kind: 'blank' },
	{ kind: 'comment', text: m.demo_c2() },
	{ kind: 'cmd', text: 'am asset sound create footstep \\' },
	{ kind: 'plain', text: '    --file audio/step.wav --bus sfx --gain 0.8 --loop' },
	{ kind: 'blank' },
	{ kind: 'comment', text: m.demo_c3() },
	{ kind: 'cmd', text: 'am project validate' },
	{ kind: 'cmd', text: 'am project build --output dist/' }
];

export const scriptSession = (): TerminalLine[] => [
	{ kind: 'comment', text: m.script_c1() },
	{ kind: 'cmd', text: 'am project list --json' },
	{ kind: 'cmd', text: 'am asset sound list --json' },
	{ kind: 'cmd', text: 'am project validate --json' },
	{ kind: 'blank' },
	{ kind: 'comment', text: m.script_c2() },
	{ kind: 'cmd', text: 'am --non-interactive asset event delete play_music --yes' }
];

export const sourceSession = (): TerminalLine[] => [
	{ kind: 'comment', text: m.src_c1() },
	{ kind: 'plain', text: 'git clone https://github.com/AmplitudeAudio/cli.git' },
	{ kind: 'plain', text: 'git clone https://github.com/AmplitudeAudio/sdk.git' },
	{ kind: 'plain', text: 'export AM_SDK_PATH="$(pwd)/sdk"' },
	{ kind: 'plain', text: 'cd cli && cargo build' },
	{ kind: 'blank' },
	{ kind: 'comment', text: m.src_c2() },
	{ kind: 'cmd', text: 'am sdk check' },
	{ kind: 'blank' },
	{ kind: 'comment', text: m.src_c3() },
	{ kind: 'cmd', text: 'am completions zsh > ~/.zfunc/_am' }
];
