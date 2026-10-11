{ pkgs, lib, ... }:
{
    programs.kitty = {
        enable = true;
        settings = {
            window_padding_width = "2 2 2 2";
        };
    };
}
