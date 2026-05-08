{
  description = "Elite OSINT & Pentesting NixOS Flake (i7-7800X, 138GB RAM, RX 480 Vulkan AI)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ (import ./overlays/ai-vulkan.nix) ];
    };

  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit pkgs; };
      modules = [
        ./configuration.nix
        ./modules/security/pentest.nix

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.architect = { config, pkgs, ... }: {
            home.stateVersion = "24.05";
            # Dotfiles mapping omitted here as they are explicitly detailed below
          };
        }
      ];
    };
  };
}
