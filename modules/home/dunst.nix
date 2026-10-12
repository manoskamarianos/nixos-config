{ ... }:
{
    services.dunst = {
        enable = true;

        # Colors come from Stylix; this is geometry only. Without an explicit
        # frame width the popup is base01 on a base00 desktop, which is too
        # subtle to read as a separate surface.
        settings.global = {
            frame_width = 2;
            corner_radius = 8;
            offset = "15x15";
        };
    };
}
