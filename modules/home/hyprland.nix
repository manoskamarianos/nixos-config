{ config, lib, pkgs, ... }:
let
  c = config.lib.stylix.colors;
in
{
    wayland.windowManager.hyprland = {
        enable = true;

        # Stylix defaults the active border to base0D (bright blue), which is
        # too loud. base03/base02 keep the focus cue without the accent color.
        # Key spelling must match Stylix's for mkForce to override it.
        settings.config.general = {
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

        # Writes hypr/hyprland.lua; "hyprlang" is the legacy .conf path.
        configType = "lua";

        # Appended after Stylix's `settings`.
        extraConfig = builtins.readFile ../../dotfiles/hypr/hyprland.lua;
    };

    # Home Manager only emits .luarc.json when it owns the Hyprland package,
    # which it does not here, so point lua_ls at the stubs directly.
    xdg.configFile."hypr/.luarc.json".text = builtins.toJSON {
        workspace.library = [ "${pkgs.hyprland}/share/hypr/stubs" ];
        diagnostics.globals = [ "hl" ];
    };

    home.packages = with pkgs; [
        brightnessctl
        playerctl
        pamixer
    ];
}
