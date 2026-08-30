{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
	pname = "siclone";
	version = "0.1.0";

	src = ./.;

	nativeBuildInputs = with pkgs; [
		pkg-config
	];

	buildInputs = with pkgs; [
		gtk3
		gtk-layer-shell
		libayatana-appindicator
		libdbusmenu-gtk3
	];

	buildPhase = ''
		runHook preBuild
		$CC -O2 base.c read.c gui.c $(pkg-config --cflags --libs gtk+-3.0 gtk-layer-shell-0  dbusmenu-gtk3-0.4 ayatana-appindicator3-0.1) -o siclone
		runHook postBuild
	'';

	installPhase = ''
		runHook preInstall
		install -Dm755 siclone $out/bin/siclone
		runHook postInstall
	'';

	meta = with pkgs.lib; {
		description = "Conky-style desktop overlay using GTK Layer Shell and SNI Tray";
		platforms = platforms.linux;
		mainProgram = "siclone";
	};
}
