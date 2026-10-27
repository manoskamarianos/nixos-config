{ lib, ... }:
{
    programs.hyprland = {
        enable = true;
        withUWSM = true;
    };

    services.upower.enable = true;

    programs.hyprlock.enable = true;

    # programs.hyprlock turns this on; noctalia handles idle instead.
    services.hypridle.enable = lib.mkForce false;
}
