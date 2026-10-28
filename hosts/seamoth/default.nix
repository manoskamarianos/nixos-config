{ ... }:
{
    imports = [
        ./hardware-configuration.nix
        ./boot.nix
        ../../modules/nixos/common.nix
        ../../modules/nixos/laptop.nix
    ];

    networking.hostName = "seamoth";

    # Per host: the release this machine was first installed with. Never bump it.
    system.stateVersion = "26.05";
}
