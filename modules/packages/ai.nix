{ pkgs, user, ... }:
{
	services.ollama = {
		enable = true;
		package = pkgs.ollama-cuda;
	};
	environment.systemPackages = [ pkgs.koboldcpp ];
	systemd.user.services.sillytavern = {
		description = "SillyTavern Local Runner";
		wantedBy = [ "default.target" ];
		after = [ "network.target" ];
		
		path = [
			pkgs.git
			pkgs.nodejs
			pkgs.bash
		];

		serviceConfig = {
			Type = "simple";
			WorkingDirectory = "/home/${user}/SillyTavern";
			ExecStart = "/home/${user}/SillyTavern/start.sh";
			Restart = "on-failure";
			RestartSec = "5s";
		};
	};
}
