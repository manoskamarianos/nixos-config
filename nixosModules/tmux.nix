{ pkgs, ... }:
{
    xdg.configFile."tmux".source = ../dotfiles/tmux;

    programs.tmux = {
        enable = true;
    };
}
