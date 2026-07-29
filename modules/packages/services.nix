{ pkgs, ... }:
{
	environment.systemPackages = with pkgs; [
		dash
		tk
		vips
		xwayland-satellite
		adw-gtk3
		git
		killall
		librsvg
		gdk-pixbuf
		xdg-desktop-portal-wlr
	];
	programs.xwayland.enable = true;
	programs.npm.enable = true;
}
