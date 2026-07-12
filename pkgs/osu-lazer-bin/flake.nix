{
    description = "Osu Lazer custom flake maintained by DiceVN";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };
    outputs = { self, nixpkgs }:
        let
            system = "x86_64-linux";
            pkgs = nixpkgs.legacyPackages.${system};
            osuLazerBin= pkgs.callPackage ./osu-lazer.nix { nativeWayland = true; };
        in {
            packages.${system}.default = osuLazerBin;
        };
}
