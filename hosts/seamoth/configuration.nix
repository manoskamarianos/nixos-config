{ config, lib, pkgs, ... }:
{

    boot = {
        loader.systemd-boot.enable = true;
        loader.efi.canTouchEfiVariables = true;

        kernelPackages = pkgs.linuxPackages_latest;

        plymouth.enable = true;

        resumeDevice = "/dev/mapper/luks-10cc7b85-c764-4e1b-ab98-84ae6d62aed6";

        # Enable "Silent boot"
        consoleLogLevel = 3;
        initrd.verbose = false;
        kernelParams = [
            "quiet"
            "rd.udev.log_level=3"
            "rd.systemd.show_status=auto"
        ];

        # Hide the OS choice for bootloaders.
        # It's still possible to open the bootloader list by pressing any key
        # It will just not appear on screen unless a key is pressed
        loader.timeout = 0;

        initrd.luks.devices."luks-10cc7b85-c764-4e1b-ab98-84ae6d62aed6".device = "/dev/disk/by-uuid/10cc7b85-c764-4e1b-ab98-84ae6d62aed6";
        initrd.kernelModules = [ "amdgpu" ];
    };

    powerManagement.enable = true;

    services.logind.settings.Login = {
        HandleLidSwitch = "suspend-then-hibernate";
        HandleLidSwitchExternalPower = "suspend";
        HandlePowerKey = "hibernate";
    };

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

    programs.hyprland = {
        enable = true;
        withUWSM = true;
    };

    programs.hyprlock.enable = true;

    programs.dconf.enable = true;

    programs.bash.promptInit = ''
        PS1='[\u@\h \w]\$ '
    '';

    xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    fonts.packages = [ pkgs.nerd-fonts.symbols-only ];

    nixpkgs.config.allowUnfree = true;

    stylix.enable = true;
    stylix.polarity = "dark";
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    environment.systemPackages = with pkgs; [
        xbacklight
    ];

    system.stateVersion = "26.05";
}
