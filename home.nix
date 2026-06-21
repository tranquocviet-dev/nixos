{ pkgs, config, ... }: {
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
    ".config/niri/v5.kdl" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos/symlinkfiles/niri/v5.kdl";
    };
    ".config/helix/config.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos/symlinkfiles/helix/config.toml";
    };
    ".config/helix/languages.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos/symlinkfiles/helix/languages.toml";
    };
  };
}
