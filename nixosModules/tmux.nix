{ pkgs, ... }:
{
    programs.tmux = {
        enable = true;
        extraConfig = builtins.readFile ../dotfiles/tmux/tmux.conf;
        plugins = with pkgs.tmuxPlugins; [
            sensible
            dotbar
        ];
    };
}
