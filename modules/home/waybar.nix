{ ... }:
{
    programs.waybar.enable = true;
    xdg.configFile."waybar/config".source = ../../dotfiles/waybar/config;

    # Stylix contributes only the base16 palette and font; the layout below is ours.
    stylix.targets.waybar.addCss = false;
    programs.waybar.style = builtins.readFile ../../dotfiles/waybar/style.css;
}
