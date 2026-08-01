{ pkgs, ... }:
{
	fonts.enableDefaultPackages = true;
	fonts.fontDir.enable = true;
	fonts.packages = with pkgs; [
		noto-fonts-cjk-sans
		nerd-fonts.noto
	];
}
