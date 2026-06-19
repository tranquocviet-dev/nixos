{
  description = "NixOS configuration with Noctalia";

  inputs = {
    noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
    };
    nix-gaming.url = "github:fufexan/nix-gaming";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        inputs.hjem.nixosModules.default
        
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.dice = {
            imports = [ ./home.nix ];
          };
        }
        # ... other modules
        ./noctalia-greeter.nix
        ./noctalia.nix
        ./configuration.nix
        ./hardware-configuration.nix
        ./programs.nix
        ./nixgaming.nix
        ./hjem.nix
      ];
    };
  };
}
