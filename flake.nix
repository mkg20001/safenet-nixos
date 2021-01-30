{
  description = "Safenet Authentication Client for nixOS";

  outputs = { self, nixpkgs }:

    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in

    {
      overlay = import ./overlay.nix;

      defaultPackage = forAllSystems (system: (import nixpkgs {
        inherit system;
        overlays = [ self.overlay ];
      }).safenetauthenticationclient);

      nixosModules.SAC = import ./module.nix;

    };
}
