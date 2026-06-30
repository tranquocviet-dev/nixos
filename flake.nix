{
  description = "NixOS configuration with Noctalia";

  inputs = {
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
    osu-nixos.url = "github:afanetd/linux-osu-stable-installer-nixos";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nix-index-database, osu-nixos, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.dice = {
            imports = [ ./modules/home.nix ];
          };
        }
        # ... other modules
        ./modules/inputs/noctalia-greeter.nix
        ./modules/inputs/noctalia.nix
        ./modules/inputs/nixgaming.nix
        ./modules/hardware-configuration.nix
        ./modules/boot.nix
        ./modules/nix-ld.nix
        ./modules/nixsettings.nix
        ./modules/nh.nix
        ./modules/nvidia.nix
        ./modules/fish.nix
        ./modules/fonts.nix
        ./modules/configuration.nix
        ./modules/programs.nix
        # comma stuff
        nix-index-database.nixosModules.default {
          programs.nix-index-database.comma.enable = true;
        }
        # custom osu lazer and other packages
        ({ pkgs, ... }: {
          nixpkgs.overlays = [
            (final: prev: {
              # This replaces the original package with your custom version system-wide
              osu-lazer-bin-custom = final.callPackage ./pkgs/osu-lazer-bin/package.nix { };
            })
          ];
        })
        # osu stable
        {
          environment.systemPackages = [
            # Install the package
            # osu-nixos.packages.x86_64-linux.default
          ];
        }
      ];
    };
    homeConfigurations = {
      dice = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ ./modules/home.nix ]; # Or wherever your home.nix is
      };
    };
  };
}
