{ pkgs, ... }:
{
  fonts.enableDefaultPackages = true;
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    roboto
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term-slab
    nerd-fonts.jetbrains-mono
    nerd-fonts.comic-shanns-mono
    nerd-fonts.roboto-mono
    sarasa-gothic
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    maple-mono.NF-CN
    maple-mono.NF
  ];
}
