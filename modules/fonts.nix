{ pkgs, ... }:
{
  fonts.enableDefaultPackages = true;
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    roboto
    nerd-fonts.iosevka-term-slab
    nerd-fonts.roboto-mono
    noto-fonts-cjk-sans
    sarasa-gothic
  ];
}
