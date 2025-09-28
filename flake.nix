{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.goku = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          inputs.home-manager.nixosModules.default
          inputs.disko.nixosModules.disko
          ./hosts/goku/configuration.nix
        ];
      };

      #    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

      #    packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

    };
}
