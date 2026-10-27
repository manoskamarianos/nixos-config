{ ... }:
{
    programs.noctalia = {
        enable = true;

        settings = {
            bar.default = {
                background_opacity = 0.88;
                start = [ "workspaces" ];
                end = [
                    "tray"
                    "clipboard"
                    "notifications"
                    "bluetooth"
                    "network"
                    "volume"
                    "brightness"
                    "battery"
                    "session"
                ];
            };
            
            control_center.shortcuts = [
                { type = "wifi"; }
                { type = "bluetooth"; }
                { type = "nightlight"; }
                { type = "notification"; }
                { type = "power_profile"; }
            ];

            location.auto_locate = true;

            shell.corner_radius_scale = 2.0;

            widget.network.show_label = false;

            wallpaper.directory = "/home/manos/Pictures/Wallpapers";

            theme.templates = {
                enable_builtin_templates = true;
                builtin_ids = [ "hyprland" "kitty" "gtk3" "gtk4" "qt" ];

                enable_community_templates = true;
                community_ids = [ "claude-code" "fzf" "neovim" "tmux" "zen-browser" ];
            };

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

            # Templates rewrite their theme files but cannot make a running
            # program re-read them. Sourcing tmux.conf rather than the theme
            # re-runs the plugin hooks, which is what rebuilds the colors
            # dotbar bakes into status-left/right.
            hooks.colors_changed = [
                "hyprctl reload"
                "tmux source-file ~/.config/tmux/tmux.conf 2>/dev/null || true"
            ];
        };
    };


}
