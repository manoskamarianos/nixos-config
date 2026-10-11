{ pkgs, inputs, ... }:

{
    imports = [ 
        ./nixosModules/nvf.nix 
        ./nixosModules/tmux.nix 
        ./homeManagerModules/kitty.nix
    ];

    xdg.configFile."hypr".source = ./dotfiles/hypr;
    xdg.configFile."rofi".source = ./dotfiles/rofi;
    xdg.configFile."waybar".source = ./dotfiles/waybar;
    home.file.".themes/Dracula".source = ./dotfiles/Dracula;
    xdg.configFile."dunst".source = "${inputs.dunst-theme}";

    home.pointerCursor = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
        size = 24;
        gtk.enable = true;
        x11.enable = true;
    };

    programs.rofi.enable = true;
    programs.waybar.enable = true;
    programs.bash.enable = true;
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
        awww
        inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    home.stateVersion = "26.05";

}
