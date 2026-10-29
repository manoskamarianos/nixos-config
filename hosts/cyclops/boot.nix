{ pkgs, ... }:
{
    boot = {
        loader.systemd-boot.enable = false;
        loader.efi.canTouchEfiVariables = true;
        loader.grub = {
            enable = true;
            efiSupport = true;
            device = "nodev";
            useOSProber = true;

            theme = pkgs.sleek-grub-theme.override { withStyle = "dark"; };

            gfxmodeEfi = "1920x1080";
            gfxpayloadEfi = "keep";
            default = "saved";
            extraGrubInstallArgs = [
                "--modules=tpm"
                "--disable-shim-lock"
            ];

            extraInstallCommands = ''
                ${pkgs.sbctl}/bin/sbctl sign /boot/EFI/NixOS-boot/grubx64.efi
                for f in /boot/kernels/*-bzImage; do
                    ${pkgs.sbctl}/bin/sbctl sign "$f"
                done
            '';
        };

        kernelPackages = pkgs.linuxPackages_latest;

        plymouth.enable = true;

        # Enable "Silent boot"
        consoleLogLevel = 3;
        kernelParams = [
            "quiet"
            "rd.udev.log_level=3"
            "rd.systemd.show_status=auto"
            "video=HDMI-A-1:d"
            "video=DVI-D-1:d"
        ];

        initrd.luks.devices."luks-2ebd7131-e655-4985-9845-023da79f76e3".device = "/dev/disk/by-uuid/2ebd7131-e655-4985-9845-023da79f76e3";
        initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_drm" ];
    };

    environment.systemPackages = [ pkgs.sbctl ];
}
