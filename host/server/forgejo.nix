{ config, pkgs, ... }:

{
	services.forgejo = {
		enable = true;
		database.type = "sqlite3";
		settings = {
			server = {
				HTTP_PORT = 3000;
				DOMAIN = "192.168.1.50"; # Replace with your server's IP or hostname
				ROOT_URL = "http://192.168.1.50:3000/";
			};
			service = {
				DISABLE_REGISTRATION = false; # Set to true after creating your admin account
			};
		};
	};

	# Open the web port in the firewall
	networking.firewall.allowedTCPPorts = [ 3000 ];
}
