{ stdenv
, dpkg
, autoPatchelfHook
, wrapGAppsHook
, gtk2
, gtk2-x11
, gdk-pixbuf
, glib
, pcsclite
, openssl
, lib
}:

stdenv.mkDerivation {
  pname = "safenet";
  
  version = "9.0.43";
  
  src = fetchurl {
    url = "https://download.comodo.com/SAC/linux/deb/x64/SafenetAuthenticationClient-9.0.43-0_amd64.deb";
    sha256 = "1an7wyhkwh9fkxg176g2y460wpkpxakyvy4lcv7rwip6pm341jk8";
  };
  
  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook
  ];

  buildInputs = [
    gtk2
    gtk2-x11
    gdk-pixbuf
    glib
    pcsclite
    openssl.out
  ];
  
  unpackPhase = ''
    dpkg -x $src source
    cd source
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ openssl.out ]}:$out/lib")
  '';

  installPhase = ''

    mkdir $out
    for f in usr/lib/*; do
      ln -s $(readlink $f | sed "s|/lib/||g") lib/$(basename $f)
    done
    rm -rf usr/lib
    mv lib/udev etc/udev
    mv lib usr/lib

    for f in $(find -type f -iname "*.so*"); do
      patchelf --add-needed libcrypto.so $f
    done

    mv usr/* $out
    mv etc $out/etc
    
    mkdir -p $out/pcsc/drivers
    cp -rf $out/share/eToken/drivers/aks-ifdh.bundle $out/pcsc/drivers
    chmod +x $out/pcsc/drivers/aks-ifdh.bundle/Contents/Linux/libAksIfdh.so.9.0
    ln -f -s libAksIfdh.so.9.0 $out/pcsc/drivers/aks-ifdh.bundle/Contents/Linux/libAksIfdh.so
  '';
}
