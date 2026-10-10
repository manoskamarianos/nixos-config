{ config, lib, pkgs, inputs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."luks-10cc7b85-c764-4e1b-ab98-84ae6d62aed6".device = "/dev/disk/by-uuid/10cc7b85-c764-4e1b-ab98-84ae6d62aed6";
  boot.initrd.kernelModules = [ "amdgpu" ];

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
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics.enable = true;

  services.displayManager.sddm.enable = true;
  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;

  fonts.packages = [ pkgs.nerd-fonts.symbols-only ];

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
}
