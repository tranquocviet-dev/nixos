{ inputs, ...}:
{
  environment.systemPackages = [
    # Install the package
    inputs.osu-stable.packages.x86_64-linux.default
  ];
}
