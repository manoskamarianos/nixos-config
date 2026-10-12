{ pkgs, ... }:
let
  sddm-astronaut = (pkgs.sddm-astronaut.override {
    embeddedTheme = "purple_leaves";  # or any other theme
    themeConfig = {
    #   # Customize colors and settings
    #   HeaderTextColor = "#d5c4a1";
      Background = "Backgrounds/hunterxhunter-blue.jpg";
    };
  }).overrideAttrs (oldAttrs: {
    # Optional: Inject custom background image
    installPhase = oldAttrs.installPhase + ''
      chmod u+w $out/share/sddm/themes/sddm-astronaut-theme/Backgrounds/
      cp ${../../assets/hunterxhunter-blue.jpg} \
        $out/share/sddm/themes/sddm-astronaut-theme/Backgrounds/hunterxhunter-blue.jpg
    '';
  });
in
{
  environment.systemPackages = [ sddm-astronaut ];
  
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
    extraPackages = with pkgs; [
      kdePackages.qtmultimedia # Required for video backgrounds/audio
    ];
    theme = "sddm-astronaut-theme";
  };
}
