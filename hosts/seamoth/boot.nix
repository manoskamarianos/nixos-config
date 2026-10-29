{ pkgs, ... }:
{
    boot = {
        loader.systemd-boot.enable = true;
        loader.efi.canTouchEfiVariables = true;

        kernelPackages = pkgs.linuxPackages_latest;

        plymouth.enable = true;

        resumeDevice = "/dev/mapper/luks-10cc7b85-c764-4e1b-ab98-84ae6d62aed6";

        # Enable "Silent boot"
        consoleLogLevel = 3;
        kernelParams = [
            "quiet"
            "rd.udev.log_level=3"
            "rd.systemd.show_status=auto"
        ];

        # Hide the OS choice for bootloaders.
        # It's still possible to open the bootloader list by pressing any key
        loader.timeout = 0;

        initrd.luks.devices."luks-10cc7b85-c764-4e1b-ab98-84ae6d62aed6".device = "/dev/disk/by-uuid/10cc7b85-c764-4e1b-ab98-84ae6d62aed6";
        initrd.kernelModules = [ "amdgpu" ];
    };
}
