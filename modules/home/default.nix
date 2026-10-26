{ pkgs, inputs, ... }:

{
    imports = [ 
        ./nvf.nix 
        ./tmux.nix 
        ./kitty.nix
        ./hyprsunset.nix
        ./git.nix
        ./rofi.nix
        ./waybar.nix
        ./dunst.nix
        ./hyprland.nix
        ./fzf.nix
        ./bash.nix
        ./anki.nix
    ];

    home.pointerCursor = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
        size = 24;
        gtk.enable = true;
        x11.enable = true;
    };

    home.sessionVariables = {
        EDITOR = "nvim";
        SSH_AUTH_SOCK = "/home/manos/.bitwarden-ssh-agent.sock";
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
        baobab
    ];

    home.stateVersion = "26.05";

}
