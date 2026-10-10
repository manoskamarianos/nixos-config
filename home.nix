{ pkgs, inputs, ... }:

{
  imports = [ ./nixosModules/nvf.nix ];
  
  xdg.configFile."hypr".source = ./dotfiles/hypr;
  xdg.configFile."rofi".source = ./dotfiles/rofi;
  xdg.configFile."waybar".source = ./dotfiles/waybar;
  # xdg.configFile."tmux".source = ./dotfiles/tmux;
  xdg.configFile."kitty".source = ./dotfiles/kitty;
  xdg.configFile."dunst".source = "${inputs.dunst-theme}";

  home.stateVersion = "26.05";

}
