# Single source of truth for fonts. Imported by the modules that have to
# declare a font themselves: fontconfig defaults, gtk, qt and kitty.
{ pkgs }:
{
    mono = {
        name = "DejaVu Sans Mono";
        package = pkgs.dejavu_fonts;
    };

    sans = {
        name = "DejaVu Sans";
        package = pkgs.dejavu_fonts;
    };

    serif = {
        name = "DejaVu Serif";
        package = pkgs.dejavu_fonts;
    };

    emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-color-emoji;
    };

    sizes = {
        applications = 12;
        terminal = 11; # kitty's own default
    };
}
