{lib, inputs, system, ...}:
{
  home.packages = [
    inputs.woomer.packages.${system}.default
    # ....
  ];
  # ....
}
