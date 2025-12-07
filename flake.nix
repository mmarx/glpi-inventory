{
  description = "GLPI inventory for NixOS";

  inputs = {
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs =
    inputs@{
      self,
      utils,
      ...
    }:
    utils.lib.mkFlake {
      inherit self inputs;

      overlays = rec {
        glpi-inventory = final: prev: { glpi-agent = final.callPackage ./glpi-agent { }; };
        default = glpi-inventory;
      };

      nixosModules = {
        glpi-inventory = ./glpi-inventory.nix;
      };

      channels.nixpkgs.overlaysBuilder = channels: [ self.overlays.default ];

      outputsBuilder = channels: {
        packages = utils.lib.exportPackages { inherit (self.overlays) default; } channels;
      };
    };
}
