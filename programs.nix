{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # lsp
    marksman
    pyright
    nixd
    lua-language-server
    # services
    tk
    vips
    xwayland
    xwayland-satellite
    adw-gtk3
    gnome-tweaks
    git
    killall
    # apps
    tuxedo
    uv
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
    neovim
    peazip
    spotify
    mesa-demos
    typst
    btop
    lshw
    foot
    osu-lazer-bin
    mpv
    feh
    alacritty
    nwg-look
    fastfetch
    vesktop
    ps_mem
    pcmanfm
    obs-studio
    pandoc
    # fonts and themes and icons
    # Essential for rendering Japanese text correctly
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    # Useful optional Japanese fonts
    ipafont
    kochi-substitute
    
    kdePackages.breeze-icons
    mint-x-icons
  ];
  programs.niri.enable = true;
  programs.npm.enable = true;
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
  fonts.packages = with pkgs; [
    
    victor-mono
    nerd-fonts.gohufont
    nerd-fonts.iosevka
    iosevka
    sarasa-gothic
    maple-mono.NF-CN
    maple-mono.NF
  ];
}
