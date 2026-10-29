# Settings and modules that hold on every machine in this flake. Hosts import
# this, then add their own hardware, their bootloader, and their form factor
# (laptop.nix or desktop.nix).
{ ... }:
{
    imports = [
        ./audio.nix
        ./bluetooth.nix
        ./sddm.nix
        ./hyprland.nix
        ./theming.nix
        ./networking.nix
        ./virtualisation.nix
        ./graphics.nix
        ./steam.nix
    ];

    users.users.manos = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "libvirtd" ];
        initialPassword = "change_me";
    };

    services.automatic-timezoned.enable = true;

    services.mullvad-vpn.enable = true;
    # services.mullvad-vpn.gui.enable = true;

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
