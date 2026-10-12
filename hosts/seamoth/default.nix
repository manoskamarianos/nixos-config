{ config, lib, pkgs, ... }:
{
    imports = [
        ./hardware-configuration.nix
        ./boot.nix
        ../../modules/nixos/audio.nix
        ../../modules/nixos/bluetooth.nix
        ../../modules/nixos/sddm.nix 
        ../../modules/nixos/desktop.nix
        ../../modules/nixos/theming.nix
        ../../modules/nixos/networking.nix
        ../../modules/nixos/bash.nix
    ];

    powerManagement.enable = true;

    services.logind.settings.Login = {
        HandleLidSwitch = "suspend-then-hibernate";
        HandleLidSwitchExternalPower = "suspend";
        HandlePowerKey = "hibernate";
    };

    time.timeZone = "Europe/Athens";

    networking.hostName = "seamoth";

    users.users.manos = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager"];
        initialPassword = "change_me";
    };

    # services.xserver.enable = true;
    # services.xserver.videoDrivers = [ "amdgpu" ];

    hardware.graphics.enable = true;

    environment.systemPackages = with pkgs; [
        brightnessctl
    ];

    nixpkgs.config.allowUnfree = true;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    system.stateVersion = "26.05";
}
