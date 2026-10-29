{ config, lib, ... }:
{
    imports = [
        ./hardware-configuration.nix
        ./boot.nix
        ../../modules/nixos/common.nix
        ../../modules/nixos/desktop.nix
        ../../modules/nixos/drm-connector.nix
        ../../modules/nixos/nixarr.nix
    ];

    networking.hostName = "cyclops";

    # Encrypted public DNS instead of the router's, which forwards to OTE and
    # redirects blocked sites. NetworkManager must not add the router's DNS.
    networking.networkmanager.dns = lib.mkForce "none";
    services.resolved.settings.Resolve = {
        DNS = [ "1.1.1.1#cloudflare-dns.com" "9.9.9.9#dns.quad9.net" ];
        DNSOverTLS = "yes";
        DNSSEC = "allow-downgrade";
        FallbackDNS = "";
        Domains = [ "~." ];
    };

    # Hardware clock in local time to not interfear with Windows Dualboot
    time.hardwareClockInLocalTime = true;

    # Nvidia drivers for gpu
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
    hardware.nvidia.open = false;
    services.xserver.videoDrivers = [ "nvidia" ];

    # Driver for Xbox wireless controller dongle.
    hardware.xone.enable = true;

    # Media HDD
    fileSystems."/mnt/media" = {
        device = "/dev/disk/by-uuid/523ef79b-4190-47fa-8226-ffec35323878";
        fsType = "ext4";
        options = [ "defaults" "nofail" ];
    };
    
    system.stateVersion = "26.05";
}
