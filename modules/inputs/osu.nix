{ system, inputs, ...}:
{
  environment.systemPackages = [
    # Install the package
    inputs.osu-stable.packages.${system}.default
    inputs.osu-lazer-bin.packages.${system}.default
  ];
}
