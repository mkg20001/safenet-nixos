# safenet-nixos

Safenet Authentication Client for nixOS

# Usage

Import it as flake

Add the `.overlay` to nixpkgs.overlays

Add the `nixosModules.SAC` to modules

```
services.SAC.enable = true;
```

It will likely cause some rebuilds as SACTools depends on an outdated glib version
