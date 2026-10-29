{ config, pkgs, ... }:
let
    f = import ../fonts.nix { inherit pkgs; };

    # qtct reads the palette from color_scheme_path only when the style honours
    # it. Kvantum paints its own colors and ignores the palette entirely, so the
    # style has to be Fusion for noctalia's scheme to show.
    qtctConf = dir: ''
        [Appearance]
        custom_palette=true
        standard_dialogs=default
        style=Fusion
        color_scheme_path=${config.home.homeDirectory}/.config/${dir}/colors/noctalia.conf

        [Fonts]
        fixed="${f.mono.name},${toString f.sizes.applications}"
        general="${f.sans.name},${toString f.sizes.applications}"
    '';
in
{
    # Colors come from noctalia's qt template.
    qt = {
        enable = true;
        platformTheme.name = "qtct";
        style.name = "Fusion";
    };

    xdg.configFile = {
        "qt5ct/qt5ct.conf".text = qtctConf "qt5ct";
        "qt6ct/qt6ct.conf".text = qtctConf "qt6ct";
    };
}
