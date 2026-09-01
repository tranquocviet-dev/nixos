{ ... }: {
	flake.homeManagerModules.umbriel =
		{ inputs, lib, ... }:
		let
			workspaceBinds = lib.listToAttrs (
				lib.concatMap (n: [
					{
						name = "Mod+${toString n}";
						value = "workspace-switch:${toString n}";
					}
					{
						name = "Mod+Shift+${toString n}";
						value = "window-move-to-workspace:${toString n}";
					}
				]) (lib.range 1 7)
			);
		in
		{
			imports = [ inputs.umbriel.homeModules.default ];
			programs.umbriel = {
				enable = true;
				settings = {
					include.files = [ "noctalia.toml" ];
					general.autostart = [
						"noctalia"
						"fcitx5"
					];
					appearance = {
						corner_radius = 0;
					};
					layout = {
						width_presets = [
							0.5
							1.0
						];
					};
					input = {
						mouse = {
							accel_profile = "flat";
						};
					};
					output = {
						"eDP-1" = {
							mode = "1920x1080@144";
							scale = 1;
							position = [
								0
								0
							];
							tearing = true;
						};
					};
					keybinds = {

						# Media Control
						"XF86AudioRaiseVolume" = {
							action = "spawn:noctalia msg volume-up";
							allow_when_locked = true;
						};
						"XF86AudioLowerVolume" = {
							action = "spawn:noctalia msg volume-down";
							allow_when_locked = true;
						};
						"XF86AudioMute" = {
							action = "spawn:noctalia msg volume-mute";
							allow_when_locked = true;
						};
						"XF86AudioMicMute" = {
							action = "spawn:noctalia msg mic-mute";
							allow_when_locked = true;
						};
						"XF86AudioNext" = {
							action = "spawn:noctalia msg media next";
							allow_when_locked = true;
						};
						"XF86AudioPrev" = {
							action = "spawn:noctalia msg media previous";
							allow_when_locked = true;
						};
						"XF86AudioPlay" = {
							action = "spawn:noctalia msg media toggle";
							allow_when_locked = true;
						};
						"XF86AudioPause" = {
							action = "spawn:noctalia msg media stop";
							allow_when_locked = true;
						};

						# Brightness
						"XF86MonBrightnessUp" = {
							action = "spawn:noctalia msg brightness-up";
							allow_when_locked = true;
						};
						"XF86MonBrightnessDown" = {
							action = "spawn:noctalia msg brightness-down";
							allow_when_locked = true;
						};

						"Mod+Return" = "spawn:kitty";
						"Mod+Q" = "window-close";
						"Mod+Ctrl+Left" = "window-focus-left";
						"Mod+Ctrl+Right" = "window-focus-right";
						"Mod+Ctrl+Up" = "window-focus-up";
						"Mod+Ctrl+Down" = "window-focus-down";
						"Mod+Shift+S" = "window-move-to-scratchpad";
						"Mod+Shift+Space" = "scratchpad-toggle";
						"Mod+Shift+W" = "window-restore-from-scratchpad";
						"Mod+O" = "overview-toggle";
						"Mod+F" = "window-cycle-width";
						"Mod+Shift+F" = "window-toggle-fullscreen";
						"Mod+P" = "window-toggle-pinned";
						"Mod+S" = "spawn:noctalia msg panel-toggle control-center";
						"Mod+Space" = "spawn:noctalia msg panel-toggle launcher";
						"Mod+Shift+Escape" = "spawn:noctalia msg panel-toggle session";
						"Mod+Print" = "spawn:noctalia msg screenshot-region";
						"Mod+Ctrl+Print" = "spawn:noctalia msg screenshot-fullscreen";
					}
					// workspaceBinds;
				};
			};
		};
}
