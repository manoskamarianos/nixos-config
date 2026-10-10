{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dunst-theme = {
        url = "github:dracula/dunst";
        flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nvf, dunst-theme, zen-browser, ... }: {
    nixosConfigurations.seamoth = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        ./nixosModules/sddm.nix
        home-manager.nixosModules.default
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            sharedModules = [ 
                nvf.homeManagerModules.default 
            ];
            users.manos = import ./home.nix;
          };
        } 
      ];
    };
  };
}
