{ pkgs, hostName, ... }:
{

    wayland.windowManager.hyprland = {
        enable = true;

        package = null;
        portalPackage = null;

        systemd.enable = false;

        configType = "lua";

        extraConfig = builtins.readFile ../../dotfiles/hypr/hyprland.lua
                    + builtins.readFile (../../dotfiles/hypr/hosts + "/${hostName}.lua");
    };

    xdg.configFile."hypr/.luarc.json".text = builtins.toJSON {
        workspace.library = [ "${pkgs.hyprland}/share/hypr/stubs" ];
        diagnostics.globals = [ "hl" ];
    };

    home.packages = with pkgs; [
        playerctl
        wl-clipboard
    ];
}
