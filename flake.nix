{
  description = "NixOS configuration with Noctalia";

  inputs = {
    noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    noctalia = {
      url = "github:noctalia-dev/noctalia";
    };
    nix-gaming.url = "github:fufexan/nix-gaming";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.dice = {
            imports = [ ./home.nix ];
          };
        }
        # ... other modules
        ./modules/inputs/noctalia-greeter.nix
        ./modules/inputs/noctalia.nix
        ./modules/inputs/nixgaming.nix
        ./configuration.nix
        ./modules/hardware-configuration.nix
        ./programs.nix
      ];
    };
    homeConfigurations = {
      dice = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ ./home.nix ]; # Or wherever your home.nix is
      };
    };
  };
}
