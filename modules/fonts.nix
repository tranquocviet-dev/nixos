{ pkgs, ... }:
{
  fonts.enableDefaultPackages = true;
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
  	maple-mono.NF-CN
    roboto
    nerd-fonts.iosevka-term-slab
    nerd-fonts.d2coding
    nerd-fonts.roboto-mono
    noto-fonts-cjk-sans
    sarasa-gothic
  ];
}
