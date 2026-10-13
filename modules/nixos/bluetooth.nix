{ ... }: 
{
    hardware.bluetooth = {
        enable = true;
        powerOnBoot = false;
    };

    services.blueman.enable = true;

    home-manager.sharedModules = [ { services.mpris-proxy.enable = true; } ];
}
