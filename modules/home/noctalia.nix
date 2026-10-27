{ ... }:
{
    programs.noctalia = {
        enable = true;

        settings = {
            bar.default.background_opacity = 0.88;

            location = {
                custom_schedule = true;
                sunrise = "07:30";
                sunset = "21:00";
            };

            nightlight = {
                enabled = true;
                temperature_day = 6500;
                temperature_night = 3500;
            };
        };
    };
}
