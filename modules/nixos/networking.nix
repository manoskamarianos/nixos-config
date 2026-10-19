{ ... }:
{
    networking = {
        networkmanager.enable = true;
        extraHosts = 
            ''
            192.168.122.37 hackbox
            '';
    };
}
