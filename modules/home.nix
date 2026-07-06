{ system, inputs, pkgs, config, ... }: {
  home.username = "dice";
  home.homeDirectory = "/home/dice";
  home.stateVersion = "26.05";
  home.packages = [
    pkgs.vicinae
    pkgs.devenv
    pkgs.adwaita-icon-theme
    pkgs.papirus-icon-theme
  ];
  # 2. Configure GTK
  gtk = {
    enable = true;
    font.name = "Roboto Mono Nerd Font Propo";
    font.size = 16;
    # 3. Set the theme name (exact name of the theme folder)
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    
    # Optional: Set your icons and cursors
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
  programs.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true;
    };
  };
  home.file = {
    ".config/niri" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos/symlinkfiles/niri";
      force = true;
    };
    ".config/mango" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos/symlinkfiles/mango";
      force = true;
    };
    ".config/helix" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos/symlinkfiles/helix";
    };
    ".config/emacs/init.el" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos/symlinkfiles/emacs/init.el";
    };
    ".config/starship.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos/symlinkfiles/starship.toml";
    };
    ".config/emacs/autoload" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos/symlinkfiles/emacs/autoload";
    };
    ".config/emacs/themes" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos/symlinkfiles/emacs/themes";
    };
  };
}
