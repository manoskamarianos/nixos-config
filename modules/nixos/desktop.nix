{ lib, ... }:
{
    programs.hyprland = {
        enable = true;
        withUWSM = true;
    };

    services.upower.enable = true;

    services.power-profiles-daemon.enable = true;

    programs.hyprlock.enable = true;

    services.hypridle.enable = lib.mkForce false;
}
