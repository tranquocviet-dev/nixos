{ pkgs, ... }:
{
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
		obs-studio
		gimp
		localsend
		equibop
		proton-vpn
		mpv
		feh
		protonplus
	];
	programs.mango.enable = true;
	programs.firefox.enable = true;
	programs.steam.enable = true;
	programs.steam.extraCompatPackages = with pkgs; [
		proton-ge-bin
	];
}
