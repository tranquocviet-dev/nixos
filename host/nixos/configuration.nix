# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, user, ... }:

{
  time.timeZone = "Asia/Ho_Chi_Minh";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_CTYPE = "en_US.UTF-8";
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  services.xserver.enable = true;
  # services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  # users.users.dice.group = "dice";
  # users.groups.dice = { "wheel", "networkmanager" };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    description = "dice";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11"; # Did you read the comment?
  environment.variables.EDITOR = "emacs";
  environment.variables.SUDO_EDITOR = "emacs";
  system.activationScripts.binbash = {
    deps = [ "binsh" ];
    text = ''
      ln -sfn /bin/sh /bin/bash
    '';
  };
  services.flatpak.enable = true;
  # enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [
    "@wheel"
  ];
  fonts.fontconfig.enable = true;
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "ja_JP.UTF-8/UTF-8"
  ];
  environment.localBinInPath = true;
  services.orca.enable = false;
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  environment.sessionVariables = {
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "1";
  };
  networking.networkmanager.enable = true;
}
