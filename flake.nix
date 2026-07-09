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

  outputs = inputs@{ self, nixpkgs, home-manager, nix-index-database, osu-stable, osu-lazer-bin, ... }:
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
      	(inputs.import-tree ./modules)
      ];
    };
    homeConfigurations = {
      dice = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home_manager/home.nix ]; # Or wherever your home.nix is
      };
    };
  };
}
