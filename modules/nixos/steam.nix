{ pkgs, ... }:
{
    programs.steam = {
        enable = true;
        gamescopeSession.enable = true;
        extraCompatPackages = with pkgs; [
            proton-ge-bin
        ];
    };

    programs.gamemode.enable = true;

    environment.systemPackages = with pkgs; [
        mangohud
        protonup-qt
    ];

    # environment.sessionVariables = {
    #     STEAM_EXTRA_COMPAT_TOOLS_PATHS = 
    #         "/home/manos/.steam/root/compatibilitytools.d";
    # };
}
