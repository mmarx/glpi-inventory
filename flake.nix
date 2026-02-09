{
  description = "GLPI inventory for NixOS";

  inputs = {
    dried-nix-flakes.url = "github:cyberus-technology/dried-nix-flakes";
    nixpkgs.url = "https://channels.nixos.org/nixos-25.11/nixexprs.tar.xz";
  };

  outputs =
    inputs:
    inputs.dried-nix-flakes inputs (inputs: {
      overlays =
        let
          glpi-inventory = final: prev: { glpi-agent = final.callPackage ./glpi-agent { }; };
        in
        {
          inherit glpi-inventory;
          default = glpi-inventory;
        };

      packages =
        let
          glpi-agent = inputs.nixpkgs.legacyPackages.callPackage ./glpi-agent { };
        in
        {
          inherit glpi-agent;
          default = glpi-agent;
        };

      nixosModules = {
        glpi-inventory = ./glpi-inventory.nix;
      };
    });
}
