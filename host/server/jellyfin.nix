{ pkgs, ... }:

{
	# Enable Jellyfin service and open port 8096
	services.jellyfin = {
		enable = true;
		openFirewall = true;
	};

	# Enable hardware acceleration drivers
	hardware.graphics = {
		enable = true;
		extraPackages = with pkgs; [
			intel-media-driver	# VA-API / QSV driver (Broadwell and newer)
			intel-compute-runtime # OpenCL support for HDR tone mapping
			vpl-gpu-rt			# oneVPL runtime for Intel QSV (11th Gen+)
		];
	};

	# Optional: add jellyfin user to video/render groups if using custom storage paths
	users.users.jellyfin.extraGroups = [ "video" "render" ];
}