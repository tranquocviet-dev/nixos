{ ... }:
{
	security = {
		sudo.enable = false;
		run0 = {
			enable = true;
			enableSudoAlias = true;
			wheelNeedsPassword = true;
			persistentAuth = {
				enable = true;
				enableRemote = true;
			};
		};
	};
}
