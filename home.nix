{ pkgs, ... }: {
  home.stateVersion = "26.05";
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
      name = "breeze-dark";
      package = pkgs.kdePackages.breeze-icons;
    };
  };
}
