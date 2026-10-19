{ ... }:
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
        ../../modules/nixos/virtualisation.nix
        ../../modules/nixos/graphics.nix
        ../../modules/nixos/steam.nix
    ];

    networking.hostName = "seamoth";
    time.timeZone = "Europe/Athens";

    users.users.manos = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "libvirtd"];
        initialPassword = "change_me";
    };

    services.logind.settings.Login = {
        HandleLidSwitch = "suspend-then-hibernate";
        HandleLidSwitchExternalPower = "suspend";
    };

    # environment.systemPackages = with pkgs; [
    # ];

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    system.stateVersion = "26.05";
}
