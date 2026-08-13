{ pkgs, ... }:
{
	fonts.enableDefaultPackages = true;
	fonts.fontDir.enable = true;
	fonts.packages = with pkgs; [
		nerd-fonts.noto
	];
}
