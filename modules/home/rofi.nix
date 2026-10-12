{ config, lib, ... }:
let
  inherit (config.lib.formats.rasi) mkLiteral;
  c = config.lib.stylix.colors.withHashtag;
in
{
    # Stylix tints every other row by default.
    stylix.targets.rofi.alternatePattern = false;

    programs.rofi = {
        enable = true;

        # Rendered into the `configuration { }` block of config.rasi.
        # The font comes from Stylix.
        extraConfig = {
            drun.display-name = "";
            run.display-name = "";
            window.display-name = "";
            timeout = {
                delay = 10;
                action = "kb-cancel";
            };
        };

        # Layout only — colors are merged in by Stylix's rofi target.
        theme = {
            "*" = {
                border = 0;
                margin = 0;
                padding = 0;
                spacing = 0;
            };
            # base00 is also the terminal background, so rofi needs to sit a
            # step up (base01) with a border or it disappears into whatever
            # is behind it.
            "window" = {
                transparency = "real";
                width = mkLiteral "700px";
                # Stylix sets this to @background (base00); override it.
                background-color = lib.mkForce (mkLiteral "@lightbg");
                border = mkLiteral "2px";
                border-color = mkLiteral c.base03;
                border-radius = mkLiteral "8px";
            };
            "mainbox".children = map mkLiteral [ "inputbar" "listview" ];
            "inputbar" = {
                background-color = mkLiteral "@lightbg";
                children = map mkLiteral [ "prompt" "entry" ];
            };
            "entry".padding = mkLiteral "12px 3px";
            "prompt".padding = mkLiteral "12px";
            "listview".lines = 8;
            "element".children = map mkLiteral [ "element-icon" "element-text" ];
            "element-icon" = {
                padding = mkLiteral "10px 10px";
                size = mkLiteral "20px";
            };
            "element-text".padding = mkLiteral "10px 0";

            # Rows inherit the window surface instead of painting their own
            # background, so the whole popup reads as one panel.
            "listview".background-color = mkLiteral "transparent";
            "element normal.normal".background-color = lib.mkForce (mkLiteral "transparent");
            "element alternate.normal".background-color = lib.mkForce (mkLiteral "transparent");
        };
    };

    # Scripts invoked from the Waybar network module.
    xdg.configFile."rofi/wifi".source = ../../dotfiles/rofi/wifi;
}
