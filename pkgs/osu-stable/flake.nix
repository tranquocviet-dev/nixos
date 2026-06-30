{
  description = "osu! stable installer for NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      osuInstaller = pkgs.callPackage ./osu-pkg.nix { };
    in {
      packages.${system}.default = osuInstaller;
    };
}
