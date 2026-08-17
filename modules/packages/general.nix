{ ... }: {
	flake.nixosModules.packages-general = { pkgs, ... }: {
		environment.systemPackages = with pkgs; [
			spotify
			rhythmbox
			upscayl
			libreoffice
			losslesscut-bin
			gpu-screen-recorder
			imv
			kitty
			krita
			protontricks
			emacs-pgtk
			gimp
			localsend
			equibop
			proton-vpn
			mpv
			feh
			protonplus
			gromit-mpx
			gpu-screen-recorder-gtk
			wl-screenrec
			mangohud
			r2modman
			direnv
			ghostty
			tack
			audacity
			zed-editor
		];
		programs.mango.enable = true;
		programs.niri.enable = true;
		programs.firefox.enable = true;
		programs.steam.enable = true;
		programs.steam.extraCompatPackages = with pkgs; [
			proton-ge-bin
		];
		programs.obs-studio = {
			enable = true;
			enableVirtualCamera = true;
			
			# optional Nvidia hardware acceleration
			package = (
				pkgs.obs-studio.override {
					cudaSupport = true;
				}
			);
			
			plugins = with pkgs.obs-studio-plugins; [
				droidcam-obs
				wlrobs
				obs-backgroundremoval
				obs-pipewire-audio-capture
				obs-vaapi #optional AMD hardware acceleration
				obs-gstreamer
				obs-vkcapture
			];
		};
	};
}
