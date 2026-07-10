{
  description = "NixOS configuration with Noctalia";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    import-tree.url = "github:denful/import-tree";

    nix-index-database = {
	    url = "github:nix-community/nix-index-database";
	    inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter";

    home-manager = {
    	url = "github:nix-community/home-manager";
    	inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia.url = "github:noctalia-dev/noctalia";

    nix-gaming.url = "github:fufexan/nix-gaming";

    osu-stable.url = "path:./pkgs/osu-stable";
    osu-lazer-bin.url = "path:./pkgs/osu-lazer-bin";

    freesmlauncher = {
    	url = "github:FreesmTeam/FreesmLauncher";
    	inputs.nixpkgs.follows = "nixpkgs";
  	};
  };

  outputs = { self, nixpkgs, home-manager, nix-index-database, ... }@inputs: {
	  nixosConfigurations = let
			mkSystem = hostname:
			{
				system ? "x86_64-linux",
				user ? "dice",
			}:
		    nixpkgs.lib.nixosSystem {
		        system = system;
		        modules = [
		            { networking.hostName = hostname; }
		            (inputs.import-tree ./host/${hostname})
		            (inputs.import-tree ./modules)
		            home-manager.nixosModules.home-manager
		            {
		                home-manager = {
		                    useUserPackages = true;
		                    useGlobalPkgs = true;
		                    extraSpecialArgs = { inherit inputs; };
		                    users.${user} = (./. + "/home_manager/${hostname}.nix");
		                };
		            }
		        ];
		        specialArgs = {
		        	inherit inputs system user;
		        };
		    };
	  in {
	  		nixos = mkSystem "nixos" { };
	  };
	};
}
