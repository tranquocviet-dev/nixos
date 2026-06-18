{ pkgs, ... }: {
  home.stateVersion = "26.05";
  home.packages = [
    pkgs.devenv
    pkgs.adwaita-icon-theme
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
      name = "Adwaita-dark";
      package = pkgs.adwaita-icon-theme;
    };
  };
}
