{ pkgs, ... }: 
{
    xdg.configFile."hypr/hyprland.conf".source = ../../dotfiles/hypr/hyprland.conf;

    home.packages = with pkgs; [
        brightnessctl
        playerctl
    ];
}
