{
	lib,
	...
}:

{
	services.immich = {
		enable = true;
		port = 2283;
		host = "0.0.0.0";
		mediaLocation = "/var/lib/immich";
		openFirewall = true;
	};
	systemd.services.immich-server.serviceConfig = {
		ProtectHome = lib.mkForce "read-only";
		ReadOnlyPaths = [ "/home/dice/storage" ];
	};
}
