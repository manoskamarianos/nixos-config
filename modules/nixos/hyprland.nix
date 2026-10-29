{ lib, ... }:
{
    programs.hyprland = {
        enable = true;
        withUWSM = true;
    };

    programs.hyprlock.enable = true;

    services.hypridle.enable = lib.mkForce false;
}
