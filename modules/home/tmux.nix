{ pkgs, ... }:
{
    programs.tmux = {
        enable = true;
        extraConfig = builtins.readFile ../../dotfiles/tmux/tmux.conf + ''

            # Written by noctalia's tmux template. -q so a missing file before
            # the first render is not an error.
            source-file -q ~/.config/tmux/themes/noctalia.conf

            # The theme raises the bar a step above the terminal background.
            # surface is the color kitty paints, so the bar blends into it.
            # Must come after the source-file above, which sets these too.
            set -gF status-style "bg=#{@noctalia_surface},fg=#{@noctalia_on_surface}"
            set -gF window-status-current-style "bg=#{@noctalia_surface},fg=#{@noctalia_on_surface},bold"
            set -gF window-status-style "bg=#{@noctalia_surface},fg=#{@noctalia_on_surface_variant}"
        '';
        plugins = with pkgs.tmuxPlugins; [
            sensible
            {
                plugin = dotbar;
                extraConfig = ''
                    source-file -q ~/.config/tmux/themes/noctalia.conf
                    set -gF @tmux-dotbar-bg "#{@noctalia_surface}"
                    set -gF @tmux-dotbar-fg "#{@noctalia_on_surface_variant}"
                    set -gF @tmux-dotbar-fg-current "#{@noctalia_primary}"
                    set -gF @tmux-dotbar-fg-session "#{@noctalia_on_surface}"
                    set -gF @tmux-dotbar-fg-prefix "#{@noctalia_primary}"
                '';
            }
        ];
    };

}
