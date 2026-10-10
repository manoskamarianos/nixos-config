{ pkgs, ... }:
{
    xdg.configFile."tmux".source = ../dotfiles/tmux;

    programs.tmux = {
        enable = true;
        plugins = [
            pkgs.tmuxPlugins.sensible
            pkgs.tmuxPlugins.dotbar
        ];
    };
}
