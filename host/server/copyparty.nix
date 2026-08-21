{ pkgs, ... }:
{
	environment.systemPackages = [ pkgs.copyparty ];

	systemd.services.copyparty = {
		description = "Copyparty File Server";
		wantedBy = [ "multi-user.target" ];
		after = [ "network.target" ];
		serviceConfig = {
			ExecStart = ''
				${pkgs.copyparty}/bin/copyparty \
					-p 3923 \
					-i 0.0.0.0 \
					-a dice:177013 \
					-v /home/dice/storage:storage:A,dice \
			'';
			StateDirectory = "copyparty";
			WorkingDirectory = "/var/lib/copyparty";
			User = "dice";
			Group = "users";
			Restart = "on-failure";
		};
	};

	# Allow access over your network/Tailscale (default port is 3923)
	networking.firewall.allowedTCPPorts = [ 3923 ];
}
