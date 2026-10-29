{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        noctalia = {
            url = "github:noctalia-dev/noctalia";
            # inputs.nixpkgs.follows = "nixpkgs";
        };
        nixarr = {
            url = "github:nix-media-server/nixarr";
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

    outputs = inputs@{ self, nixpkgs, home-manager, nvf, noctalia, zen-browser, nixarr, ... }:
    let
        # Everything a host needs beyond its own ./hosts/<host> directory. New
        # machines are one line in nixosConfigurations below.
        mkHost = host: nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
                ./hosts/${host}
                nixarr.nixosModules.default
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
