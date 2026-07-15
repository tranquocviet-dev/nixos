{ user, ... }:
{
    # Enable nh command
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 10d --keep 10";
    };
    flake = "/home/${user}/.config/nixos"; # Replace with the absolute path to your config
  };
}
