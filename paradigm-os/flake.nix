{
  description = "Paradigm OS - Bare-metal NixOS Unstable Config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      chimeric = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hardware-configuration.nix
          ./configuration.nix
          ./modules/memory-opts.nix
          ./modules/ai.nix
          ./modules/pentesting.nix
          ./modules/desktop.nix
          ./modules/virtualisation.nix
          ./modules/development.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mxi = import ./home.nix;
          }
        ];
      };
    };
  };
}
