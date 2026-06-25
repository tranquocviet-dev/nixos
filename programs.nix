{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # lsp
    vscode-css-languageserver
    superhtml
    ccls
    marksman
    ruff
    nixd
    lua-language-server
    # services
    nautilus-python
    tk
    vips
    xwayland
    xwayland-satellite
    adw-gtk3
    git
    killall
    # apps
    fsel
    pomodoro
    pywalfox-native
    godot
    thokr
    rhythmbox
    upscayl
    upscayl-ncnn
    libreoffice
    bottles
    losslesscut-bin
    tuxedo
    gpu-screen-recorder
    obsidian
    qimgv
    kitty
    zed-editor
    yazi
    krita
    protontricks
    lutris
    lutgen
    helix
    peazip
    vis
    spotify
    mesa-demos
    typst
    btop
    lshw
    foot
    mpv
    feh
    alacritty
    fastfetch
    vesktop
    ps_mem
    obs-studio
    pandoc
    # fonts and themes and icons
    # Essential for rendering Japanese text correctly
    # Useful optional Japanese fonts
    
    ];
    programs.niri.enable = true;
    programs.nautilus-open-any-terminal = {
      enable = true;
      terminal = "kitty";
    };
    programs.noctalia-greeter.enable = true;
    programs.npm.enable = true;
    programs.tmux = {
      enable = true;
      extraConfig = ''
              set-option -g default-terminal "screen-256color"
              set -g prefix C-x
              set -g base-index 1
              set -g renumber-windows on
          '';
  };
  programs.labwc.enable = true;
  programs.mangowc.enable = true;
  # Enable Fcitx5
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      kdePackages.fcitx5-configtool # GUI Config Tool
      # Addons for your specific language:
      # fcitx5-chinese-addons  # For Pinyin/Table input
      # fcitx5-mozc            # For Japanese
      qt6Packages.fcitx5-unikey          # For Vietnamese
      # fcitx5-rime            # For Rime
    ];
  };
  fonts.enableDefaultPackages = true;
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    roboto
    nerd-fonts.iosevka
    nerd-fonts.roboto-mono
    sarasa-gothic
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    maple-mono.NF-CN
    maple-mono.NF
  ];
}
