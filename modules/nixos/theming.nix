{ pkgs, ... }:
{
    stylix.enable = true;
    stylix.polarity = "dark";
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";

    fonts.packages = [ pkgs.nerd-fonts.symbols-only ];
}
