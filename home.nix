{ pkgs, inputs, ... }:

{
  imports = [ 
        ./nixosModules/nvf.nix 
        ./nixosModules/tmux.nix 
  ];
  
  xdg.configFile."hypr".source = ./dotfiles/hypr;
  xdg.configFile."rofi".source = ./dotfiles/rofi;
  xdg.configFile."waybar".source = ./dotfiles/waybar;
  xdg.configFile."kitty".source = ./dotfiles/kitty;
  home.file.".themes/Dracula".source = ./dotfiles/Dracula;
  xdg.configFile."dunst".source = "${inputs.dunst-theme}";

  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
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
