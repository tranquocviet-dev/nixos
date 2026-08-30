{
	pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
	nativeBuildInputs = with pkgs; [
		pkg-config
		bear
	];
	buildInputs = with pkgs; [
		gtk3
		gtk-layer-shell
		libayatana-appindicator
		libdbusmenu-gtk3
	];
}
