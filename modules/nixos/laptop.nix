# Form factor module for machines with a battery and a lid.
{ ... }:
{
    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;

    services.logind.settings.Login = {
        HandleLidSwitch = "suspend-then-hibernate";
        HandleLidSwitchExternalPower = "suspend";
    };
}
