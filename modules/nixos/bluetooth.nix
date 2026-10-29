{ ... }: 
{
    hardware.bluetooth = {
        enable = true;
        powerOnBoot = false;
    };

    home-manager.sharedModules = [ { services.mpris-proxy.enable = true; } ];
}
