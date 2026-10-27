{ config, lib, pkgs, ... }:
let
  c = config.lib.stylix.colors;
in
{
    wayland.windowManager.hyprland = {
        enable = true;

        # Stylix defaults the active border to base0D (bright blue), which is
        # too loud. base03/base02 keep the focus cue without the accent color.
        # Under configType = "lua" every section nests below `config`, and the
        # dotted keys must match Stylix's spelling exactly or mkForce lands on
        # a different attribute instead of overriding it. hl.config() flattens
        # `general."col.active_border"` to `general.col.active_border`.
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

        # Writes hypr/hyprland.lua, plus hypr/.luarc.json pointing at
        # Hyprland's own LSP stubs for completion on the `hl` API.
        # "hyprlang" is the legacy path and writes hypr/hyprland.conf instead.
        configType = "lua";

        # Appended after Stylix's `settings`. hl.config() assigns individual
        # leaves rather than replacing a section, so our calls merge with
        # Stylix's instead of clobbering its colors.
        extraConfig = builtins.readFile ../../dotfiles/hypr/hyprland.lua;
    };

    # Home Manager only emits hypr/.luarc.json when it owns the Hyprland
    # package, and ours comes from the NixOS module (package = null above), so
    # point lua_ls at Hyprland's own stubs here instead. Without this the `hl`
    # global reads as undefined and there is no completion on the API.
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
