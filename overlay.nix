final: prev: rec {
  glib_safenet = prev.callPackage ./glib {};

  safenetauthenticationclient = prev.callPackage ./package.nix {
    wrapGAppsHook = final.wrapGAppsHook.override {
      isGraphical = false;
    };
    glib = glib_safenet;
    gtk2 = final.gtk2.override {
      glib = glib_safenet;
      pango = final.pango.override {
        glib = glib_safenet;
        gobject-introspection = final.gobject-introspection.override {
          glib = glib_safenet;
        };
      };
    };
    gtk2-x11 = final.gtk2-x11.override {
      glib = glib_safenet;
      pango = final.pango.override {
        glib = glib_safenet;
        gobject-introspection = final.gobject-introspection.override {
          glib = glib_safenet;
        };
      };
    };
    gdk-pixbuf = final.gdk-pixbuf.override {
      glib = glib_safenet;
      gobject-introspection = final.gobject-introspection.override {
        glib = glib_safenet;
      };
    };
  };
}
