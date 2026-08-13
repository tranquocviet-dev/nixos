{ pkgs, ... }:
{
  # Bootloader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.font = "/home/dice/.config/nixos/images/unicode.pf2";
  boot.loader.grub.splashImage = ../../images/saber1080p.jpg;
  boot.loader.grub.splashMode = "normal";
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
