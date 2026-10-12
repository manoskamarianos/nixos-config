{ inputs, ... }:
{
    services.dunst.enable = true;
    xdg.configFile."dunst".source = "${inputs.dunst-theme}";
}
