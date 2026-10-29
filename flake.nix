{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
        home-manager = {
            url = "github:nix-community/home-manager/release-26.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        noctalia = {
            url = "github:noctalia-dev/noctalia";
            # inputs.nixpkgs.follows = "nixpkgs";
        };
        nvf = {
            url = "github:NotAShelf/nvf";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        zen-browser = {
            url = "github:youwen5/zen-browser-flake";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs@{ self, nixpkgs, home-manager, nvf, noctalia, zen-browser, ... }:
    let
        # Everything a host needs beyond its own ./hosts/<host> directory. New
        # machines are one line in nixosConfigurations below.
        mkHost = host: nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
                ./hosts/${host}
                home-manager.nixosModules.default
                {
                    home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        extraSpecialArgs = { inherit inputs; hostName = host; };
                        sharedModules = [
                            nvf.homeManagerModules.default
                            inputs.noctalia.homeModules.default
                        ];
                        users.manos = import ./modules/home;
                    };
                }
            ];
        };
    in
    {
        nixosConfigurations = {
            seamoth = mkHost "seamoth";
            cyclops = mkHost "cyclops";
        };
    };
}
