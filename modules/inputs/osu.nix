{ inputs, ...}:
{
  environment.systemPackages = [
    # Install the package
    inputs.osu-stable.packages.x86_64-linux.default
    inputs.osu-lazer-bin.packages.x86_64-linux.default
  ];
}
