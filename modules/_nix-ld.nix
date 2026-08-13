{ pkgs, ... }:
{
  environment.stub-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add common libraries standard binaries typically require
    stdenv.cc.cc
    glib
    libGL
    xorg.libX11
    xorg.libxcb
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    libxkbcommon
    dbus
    fontconfig
    freetype
  ];
}
