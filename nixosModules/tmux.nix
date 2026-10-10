{ pkgs, ... }:
{
    programs.tmux = {
        enable = true;
        extraConfig = builtins.readFile ../dotfiles/tmux;
        plugins = with pkgs.tmuxPlugins; [
            sensible
            dotbar
        ];
    };
}
