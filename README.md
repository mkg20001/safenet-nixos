# safenet-nixos

Safenet Authentication Client for nixOS

# Usage

NOTE: On latest nixOS the overlay does not work

You can either `nix build` and then `nix-env -i ./result` to use SACTools (SACSrv still works fine)

Or you can use a hack to use the flake's nixpkgs, by adding this to overlays

```nix
(f: a: {
  safenetauthenticationclient = SAC.defaultPackage.${pkgs.system};
})
```

---

Import it as flake

Add the `.overlay` to nixpkgs.overlays

Add the `nixosModules.SAC` to modules

```
services.SAC.enable = true;
```
