{ ... }:
{
	nixpkgs.config.allowUnfree = true;
	nix.settings = {
		substituters = [
			"https://cache.nixos.org"
			"https://cuda-maintainers.cachix.org"
		];
		trusted-public-keys = [
			"cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
			"cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
		];
		extra-substituters = [
			"https://noctalia.cachix.org"
			"https://nix-gaming.cachix.org"
		];
		extra-trusted-public-keys = [
			"noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
			"nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="

		];
	};
}
