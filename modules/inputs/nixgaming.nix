{pkgs, inputs, ...}:
{
  environment.systemPackages = [ # or home.packages
    inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.wine-tkg
  ];
}
