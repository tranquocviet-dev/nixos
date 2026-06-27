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
  boot.loader.grub.splashImage = ../images/saber1080p.jpg;
  boot.loader.grub.splashMode = "normal";
  boot.loader.grub.extraEntries = ''
    menuentry "Fedora" --class fedora --class os {
      insmod part_gpt
      insmod ext2
      insmod fat
      search --no-floppy --fs-uuid --set=root DCAB-9236
      chainloader /EFI/fedora/grubx64.efi
    }
  '';
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
