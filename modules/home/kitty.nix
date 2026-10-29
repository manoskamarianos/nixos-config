{ pkgs, ... }:
let
    f = import ../fonts.nix { inherit pkgs; };
in
{
    programs.kitty = {
        enable = true;
        settings = {
            window_padding_width = "10";
            tab_bar_style = "hidden";
        };

        font = {
            name = f.mono.name;
            size = f.sizes.terminal;
        };

        # Written by noctalia's kitty template. Its apply.sh would normally add
        # this line itself, but kitty.conf is a read-only store symlink.
        extraConfig = ''
            include themes/noctalia.conf
        '';
    };

}
