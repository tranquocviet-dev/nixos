{ ... }:
{
	nix.settings = {
		extra-substituters = [
			"https://noctalia.cachix.org"
			"https://nix-gaming.cachix.org"
			"https://freesmlauncher.cachix.org"
		];
		extra-trusted-public-keys = [
			"noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
			"nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
			"freesmlauncher.cachix.org-1:Jcp5Q9wiLL+EDv8Mh7c6L9xGk+lXr7/otpKxMOuBuDs="
		];
	};
}
