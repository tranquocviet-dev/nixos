{ pkgs, ... }:
{
    fonts.enableDefaultPackages = true;
    fonts.fontDir.enable = true;
    fonts.packages = with pkgs; [
        sarasa-gothic
        maple-mono.NF
    ];
}
