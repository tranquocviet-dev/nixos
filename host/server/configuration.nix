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
		./forgejo.nix
		./copyparty.nix
		./tailscale.nix
		./immich.nix
		./jellyfin.nix
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
	services.openssh.settings.X11Forwarding = true;
	services.openssh.settings.PasswordAuthentication = true;
	services.openssh.settings.PermitRootLogin = "yes";
	# Open ports in the firewall.
	time.timeZone = "Asia/Ho_Chi_Minh";
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
	services.xrdp = {
		enable = true;
		defaultWindowManager = "startxfce4";
		openFirewall = true;
	};
	services.xserver = {
		enable = true;
		desktopManager.xfce.enable = true;
	};
	environment.systemPackages = [
		pkgs.tigervnc
		pkgs.xorg.xinit
		pkgs.xorg.xauth
		pkgs.git
	];
	networking.firewall.allowedTCPPorts = [ 5901 ];
	programs.firefox.enable = true;
}
