{
  description = "NixOS configuration with Noctalia";

  inputs = {
    import-tree.url = "github:denful/import-tree";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    noctalia = {
      url = "github:noctalia-dev/noctalia";
    };
    nix-gaming.url = "github:fufexan/nix-gaming";
    osu-stable.url = "path:./pkgs/osu-stable";
    osu-lazer-bin.url = "path:./pkgs/osu-lazer-bin";
  };

  outputs = { nixpkgs, home-manager, nix-index-database, ... }@inputs:
  let
		mkSystem = system: hostname:
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
	                    # Home manager config (configures programs like firefox, zsh, eww, etc)
	                    users.dice = (./. + "/home_manager/${hostname}.nix");
	                };
	            }
	        ];
	        specialArgs = { inherit inputs; };
	    };
  in {
  	nixosConfigurations.nixos = mkSystem "x86_64-linux" "nixos";
    homeConfigurations = {
      dice = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [
        	./home_manager/nixos.nix
        	nix-index-database.homeModules.default
        	{ programs.nix-index-database.comma.enable = true; }
        ]; # Or wherever your home.nix is
      };
    };
  };
}
