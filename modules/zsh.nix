{ self, pkgs, specialArgs, ... }:
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      ls = "eza";
    };
    autosuggestions.enable = true;
  };
  # Set fish as the default shell for your user
  users.users.${specialArgs.user} = {
    shell = pkgs.zsh;
  };
  programs.starship.enable = true;
}
