{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # lsp
    vscode-css-languageserver
    superhtml
    ccls
    marksman
    ty
    nil
    ruff
    python3Packages.jedi-language-server
    nixd
    lua-language-server
    # services
    nautilus-python
    tk
    vips
    xwayland-satellite
    adw-gtk3
    git
    killall
    # apps
    openssl
    vesktop
    wlr-randr
    mindustry-wayland
    nodejs
    tailwindcss
    tailwindcss-language-server
    ruby
    ruby-lsp
    wl-clipboard
    luajit
    gnumake
    clang
    mpvpaper
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
    ps_mem
    obs-studio
    pandoc
    wget
    emacs-gtk
    # fonts and themes and icons
    # Essential for rendering Japanese text correctly
    # Useful optional Japanese fonts
  ];
  programs.xwayland.enable = true;
  programs.firefox.enable = true;
  programs.steam.enable = true;
  programs.steam.extraCompatPackages = with pkgs; [
    proton-ge-bin
  ];
  programs.niri.enable = true;
  programs.mangowc.enable = true;
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
      qt6Packages.fcitx5-unikey # For Vietnamese
      # fcitx5-rime            # For Rime
    ];
  };
    programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format = "$all$nix_shell$nodejs$lua$golang$rust$php$git_branch$git_commit$git_state$git_status\n$username $hostname $directory";
      character = {
        success_symbol = "[](bold green) ";
        error_symbol = "[✗](bold red) ";
      };
    };
  };
}
