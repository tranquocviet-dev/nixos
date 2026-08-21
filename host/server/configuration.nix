# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
	config,
	lib,
	pkgs,
	...
}:

{
	imports = [
		# Include the results of the hardware scan.
		./hardware-configuration.nix
	];

	# Use the systemd-boot EFI boot loader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	networking.hostName = "server"; # Define your hostname.

	# Configure network connections interactively with nmcli or nmtui.
	networking.networkmanager.enable = true;

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.dice = {
		isNormalUser = true;
		extraGroups = [
			"networkmanager"
			"wheel"
		]; # Enable ‘sudo’ for the user.
		packages = with pkgs; [
			git
		];
	};
	# Enable the OpenSSH daemon.
	services.openssh.enable = true;
	services.openssh.settings.PasswordAuthentication = true;
	services.openssh.settings.PermitRootLogin = "yes";
	# Open ports in the firewall.
	networking.firewall.allowedTCPPorts = [ 3000 ];
	time.timeZone = "Asia/Ho_Chi_Minh";
	services.forgejo = {
		enable = true;
		settings = {
			server = {
				HTTP_PORT = 3000;
				DOMAIN = "192.168.22.94";
				ROOT_URL = "http://192.168.22.94:3000/";
			};
			service = {
				DISABLE_REGISTRATION = false;
			};
		};
	};
	# networking.firewall.allowedUDPPorts = [ ... ];
	# networking.firewall.enable = false;
	system.stateVersion = "26.05"; # Did you read the comment?
	nix.settings.experimental-features = [
		"nix-command"
		"flakes"
	];
	services.logind.settings.Login = {
		HandleLidSwitch = "ignore";
		HandleLidSwitchDocked = "ignore";
		HandleLidSwitchExternalPower = "ignore";
	};
	services.tailscale.enable = true;
	# Set up routing and firewall
	services.tailscale.useRoutingFeatures = "server"; # Enables IP forwarding if you want exit node or subnet routing

	networking.firewall = {
		enable = true;
		# Always trust traffic coming in from the Tailscale network interface
		trustedInterfaces = [ "tailscale0" ];
		# Allow Tailscale UDP handshake port for direct peer-to-peer connections
		allowedUDPPorts = [ config.services.tailscale.port ];
		# Fix routing issues when using exit nodes / multi-interface setups
		checkReversePath = "loose";
	};
}
