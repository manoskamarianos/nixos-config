{ config, lib, pkgs, inputs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."luks-10cc7b85-c764-4e1b-ab98-84ae6d62aed6".device = "/dev/disk/by-uuid/10cc7b85-c764-4e1b-ab98-84ae6d62aed6";

  networking.hostName = "seamoth";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Athens";

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  virtualisation.vmVariant = {
      virtualisation = {
          memorySize = 8192;
          cores = 16;
          qemu.options = [ "-device virtio-vga" ];
      };
  };

  users.users.manos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "test";
  };

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    AQ_NO_HARDWARE_CURSORS = "1";
    LIBGL_ALWAYS_SOFTWARE = "1";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
  };
  
  fonts.packages = [ pkgs.nerd-fonts.symbols-only ];

  environment.systemPackages = with pkgs; [
    git
    discord
    spotify
    qbittorrent
    vlc
    kitty
    rofi
    waybar
    nautilus
    dunst
    tmux
    copyq
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
}
