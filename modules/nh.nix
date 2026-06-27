{ ... }:
{
    # Enable nh command
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 10d --keep 20";
    };
    flake = "/home/dice/.config/nixos"; # Replace with the absolute path to your config
  };
}
