{ pkgs, inputs, ... }:

{
    imports = [ 
        ./nvf.nix 
        ./tmux.nix 
        ./kitty.nix
        ./git.nix
        ./hyprland.nix
        ./fzf.nix
        ./bash.nix
        ./anki.nix
        ./noctalia.nix
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
        claude-code
        bitwarden-desktop
        inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
        baobab
    ];

    home.stateVersion = "26.05";

}
