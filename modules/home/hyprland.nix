{ config, lib, ... }:
let
  c = config.lib.stylix.colors;
in
{
    wayland.windowManager.hyprland = {
        enable = true;

        # Stylix defaults the active border to base0D (bright blue), which is
        # too loud. base03/base02 keep the focus cue without the accent color.
        settings.general = {
            "col.active_border" = lib.mkForce "rgb(${c.base03})";
            "col.inactive_border" = lib.mkForce "rgb(${c.base02})";
        };

        # Hyprland itself and its portal come from the NixOS module
        # (modules/nixos/desktop.nix); Home Manager only owns the config.
        package = null;
        portalPackage = null;

        # The session is started by UWSM (programs.hyprland.withUWSM), so
        # Home Manager must not also emit its own systemd activation.
        systemd.enable = false;

        # Home Manager defaults to "lua" here, which writes a Lua config and
        # never emits hypr/hyprland.conf. Our config is plain hyprlang.
        configType = "hyprlang";

        # Emitted after Stylix's `settings`, so anything set here wins.
        # Colors are deliberately left out of the file so Stylix supplies them.
        extraConfig = builtins.readFile ../../dotfiles/hypr/hyprland.conf;
    };
}
