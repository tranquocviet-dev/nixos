{ self, ... }:
{
	flake.homeManagerModules.dice = { user, ... }: {
		imports = (with self.homeManagerModules; [
			gtk-qt
			programs-mimeapps
			symlinks
			umbriel
		]);
		home.username = "${user}";
		home.homeDirectory = "/home/${user}";
		home.stateVersion = "26.05";
	};
}
