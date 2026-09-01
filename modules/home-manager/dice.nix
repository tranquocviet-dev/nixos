{ self, ... }:
{
	flake.modules.homeManager.dice = { user, ... }: {
		imports = with self.modules.homeManager; [
			gtk-qt
			programs-mimeapps
			symlinks
			umbriel
		];
		home.username = "${user}";
		home.homeDirectory = "/home/${user}";
		home.stateVersion = "26.05";
	};
}
