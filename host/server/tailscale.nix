{ config, pkgs, ... }:

{
	# Enable the Tailscale service daemon
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