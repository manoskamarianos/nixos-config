{ config, ... }:
{
    imports = [
        ./hardware-configuration.nix
        ./boot.nix
        ../../modules/nixos/common.nix
        ../../modules/nixos/desktop.nix
        ../../modules/nixos/drm-connector.nix
        ../../modules/nixos/jellyfin.nix
    ];

    networking.hostName = "cyclops";

    time.hardwareClockInLocalTime = true;

    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
    hardware.nvidia.open = false;
    services.xserver.videoDrivers = [ "nvidia" ];

    system.stateVersion = "26.05";
}
