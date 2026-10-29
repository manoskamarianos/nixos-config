{ pkgs, lib, ... }:
let
    f = import ../fonts.nix { inherit pkgs; };
in
{
    fonts.packages = lib.unique [
        pkgs.nerd-fonts.symbols-only
        f.mono.package
        f.sans.package
        f.serif.package
        f.emoji.package
    ];

    fonts.fontconfig.defaultFonts = {
        monospace = [ f.mono.name ];
        sansSerif = [ f.sans.name ];
        serif = [ f.serif.name ];
        emoji = [ f.emoji.name ];
    };

    home-manager.sharedModules = [
        ({ pkgs, ... }: {
            # Exposed to apps as org.freedesktop.appearance color-scheme by the
            # desktop portal. GTK, Qt, Electron and Firefox-based apps read it
            # to pick their dark variant; without it they default to light.
            dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

            # gtk-font-name in gtk-{3,4}.0/settings.ini. Cursor entries land in
            # the same file, from home.pointerCursor below.
            gtk = {
                enable = true;
                font = {
                    name = f.sans.name;
                    size = f.sizes.applications;
                };
            };

            home.pointerCursor = {
                package = pkgs.adwaita-icon-theme;
                name = "Adwaita";
                size = 24;
                gtk.enable = true;
                x11.enable = true;
            };
        })
    ];
}
