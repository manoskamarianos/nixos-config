{ pkgs, inputs, ... }:

{
    imports = [ 
        ./nixosModules/nvf.nix 
        ./nixosModules/tmux.nix 
    ];

    xdg.configFile."hypr".source = ./dotfiles/hypr;
    xdg.configFile."rofi".source = ./dotfiles/rofi;
    xdg.configFile."waybar".source = ./dotfiles/waybar;
    home.file.".themes/Dracula".source = ./dotfiles/Dracula;
    xdg.configFile."dunst".source = "${inputs.dunst-theme}";

    gtk = {
        enable = true;
        theme = {
            name = "Dracula";
        };
    };

    home.pointerCursor = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
        size = 24;
        gtk.enable = true;    # also wires it into gtk-3.0/gtk-4.0 settings.ini
        x11.enable = true;    # sets XCURSOR_THEME/XCURSOR_SIZE for X11/XWayland apps
    };

    programs.kitty.enable = true;
    programs.rofi.enable = true;
    programs.waybar.enable = true;
    services.dunst.enable = true;

    programs.git = {
        enable = true;
        settings = {
            user = {
                name = "Manos Pavlis-Kamarianos";
                email = "manospk160@gmail.com";
            };
        };
    };

    home.packages = with pkgs; [
        discord
        spotify
        qbittorrent
        vlc
        nautilus
        copyq
        claude-code
        bitwarden-desktop
        inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    home.stateVersion = "26.05";

}
