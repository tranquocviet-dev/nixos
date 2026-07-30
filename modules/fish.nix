{ self, pkgs, specialArgs, ... }:
{
	programs.fish = {
		enable = true;
		shellAliases = {
			ls = "eza";
			am = "emacsclient -c -e \"(load-file user-init-file)\"";
		};
	};
	# Set fish as the default shell for your user
	users.users.${specialArgs.user} = {
		shell = pkgs.fish;
	};
	programs.starship.enable = true;
}
