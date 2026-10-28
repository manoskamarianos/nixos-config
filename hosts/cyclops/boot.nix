{ pkgs, ... }:
{
    boot = {
        loader.systemd-boot.enable = true;
        loader.efi.canTouchEfiVariables = true;

        kernelPackages = pkgs.linuxPackages_latest;

        # plymouth.enable = true;

        initrd.luks.devices."luks-2ebd7131-e655-4985-9845-023da79f76e3".device = "/dev/disk/by-uuid/2ebd7131-e655-4985-9845-023da79f76e3";
    };
}
