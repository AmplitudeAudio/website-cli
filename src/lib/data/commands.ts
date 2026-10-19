import { m } from '#lib/paraglide/messages.js';

export interface CommandRow {
	cmd: string;
	flags: string;
	desc: string;
}

export interface CommandGroup {
	id: string;
	label: string;
	note: string;
	rows: CommandRow[];
}

const CRUD = 'create  list  update  delete';

// Built by functions, not constants: messages must resolve per request so each
// prerendered locale gets its own text.
export function commandGroups(): CommandGroup[] {
	return [
		{
			id: 'project',
			label: m.grp_project(),
			note: m.note_project(),
			rows: [
				{ cmd: 'am project init [name]', flags: '--template  --no-register', desc: m.cmd_project_init() },
				{ cmd: 'am project register [path]', flags: '', desc: m.cmd_project_register() },
				{ cmd: 'am project unregister <name>', flags: '--delete-files', desc: m.cmd_project_unregister() },
				{ cmd: 'am project list', flags: '--favorite  --no-favorite', desc: m.cmd_project_list() },
				{ cmd: 'am project favorite <name>', flags: '--set  --unset', desc: m.cmd_project_favorite() },
				{ cmd: 'am project info [name]', flags: '', desc: m.cmd_project_info() },
				{ cmd: 'am project validate', flags: '--sounds-only  --rtpc-only  --buses-only  …', desc: m.cmd_project_validate() },
				{ cmd: 'am project build', flags: '--output  --clean  --fail-fast', desc: m.cmd_project_build() }
			]
		},
		{
			id: 'asset',
			label: m.grp_asset(),
			note: m.note_asset(),
			rows: [
				{ cmd: 'am asset sound', flags: CRUD, desc: m.cmd_asset_sound() },
				{ cmd: 'am asset collection', flags: CRUD, desc: m.cmd_asset_collection() },
				{ cmd: 'am asset effect', flags: CRUD, desc: m.cmd_asset_effect() },
				{ cmd: 'am asset switch', flags: CRUD, desc: m.cmd_asset_switch() },
				{ cmd: 'am asset switch-container', flags: CRUD, desc: m.cmd_asset_switch_container() },
				{ cmd: 'am asset event', flags: CRUD, desc: m.cmd_asset_event() },
				{ cmd: 'am asset soundbank', flags: CRUD, desc: m.cmd_asset_soundbank() },
				{ cmd: 'am asset attenuation', flags: CRUD, desc: m.cmd_asset_attenuation() },
				{ cmd: 'am asset rtpc', flags: CRUD, desc: m.cmd_asset_rtpc() }
			]
		},
		{
			id: 'config',
			label: m.grp_config(),
			note: m.note_config(),
			rows: [
				{ cmd: 'am asset pipeline', flags: CRUD, desc: m.cmd_asset_pipeline() },
				{ cmd: 'am asset bus', flags: CRUD, desc: m.cmd_asset_bus() },
				{ cmd: 'am asset bus-file', flags: 'create  list  delete', desc: m.cmd_asset_bus_file() },
				{ cmd: 'am asset engine-config', flags: CRUD, desc: m.cmd_asset_engine_config() }
			]
		},
		{
			id: 'template',
			label: m.grp_template(),
			note: m.note_template(),
			rows: [
				{ cmd: 'am template list', flags: '', desc: m.cmd_template_list() },
				{ cmd: 'am template info <name>', flags: '', desc: m.cmd_template_info() },
				{ cmd: 'am template register <path>', flags: '', desc: m.cmd_template_register() },
				{ cmd: 'am template unregister <name>', flags: '', desc: m.cmd_template_unregister() }
			]
		},
		{
			id: 'tools',
			label: m.grp_tools(),
			note: m.note_tools(),
			rows: [
				{ cmd: 'am sdk check', flags: '', desc: m.cmd_sdk_check() },
				{ cmd: 'am completions <shell>', flags: 'bash  zsh  fish', desc: m.cmd_completions() }
			]
		}
	];
}

export const GLOBAL_FLAGS = ['--json', '--non-interactive', '-q, --quiet', '-v, --verbose'];

export function workflowSteps() {
	return [
		{ step: m.wf1_label(), title: m.wf1_title(), body: m.wf1_body(), cmd: 'am project init my_game' },
		{
			step: m.wf2_label(),
			title: m.wf2_title(),
			body: m.wf2_body(),
			cmd: 'am asset sound create explosion --file audio/explosion.wav --bus sfx'
		},
		{ step: m.wf3_label(), title: m.wf3_title(), body: m.wf3_body(), cmd: 'am project validate --sounds-only' },
		{ step: m.wf4_label(), title: m.wf4_title(), body: m.wf4_body(), cmd: 'am project build --output dist/ --clean' }
	];
}
