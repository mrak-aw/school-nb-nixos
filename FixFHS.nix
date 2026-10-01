{ pkgs, ... }:

{
  ############################################################################
  # СОВМЕСТИМОСТЬ СО СТОРОННИМИ ЛИНУКС-БИНАРНИКАМИ / APPIMAGE
  ############################################################################

  system.activationScripts.binbash = {
    text = ''
      mkdir -m 0755 -p /bin
      ln -sf ${pkgs.bash}/bin/bash /bin/bash
      ln -sf ${pkgs.bash}/bin/bash /bin/sh
    '';
    deps = [];
  };

  programs.appimage.enable = true;
  programs.appimage.binfmt = false;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    glibc
    zlib
    zstd
    bzip2
    xz
    lz4
    brotli
    libunwind
    attr
    acl
    libcap
    keyutils
    libuuid
    numactl
    systemd

    openssl
    curl
    libssh
    libssh2
    nghttp2
    c-ares
    gnutls
    libgcrypt
    libgpg-error
    krb5
    cyrus_sasl
    gsasl

    libarchive
    minizip

    fontconfig
    freetype
    harfbuzz
    fribidi
    icu
    libthai
    libdatrie
    pango
    cairo
    graphite2

    libx11
    libxext
    libxrender
    libxrandr
    libxcomposite
    libxdamage
    libxfixes
    libxtst
    libxi
    libxscrnsaver
    libxkbfile
    libxcursor
    libxinerama
    libxxf86vm
    libxmu
    libxpm
    libxt
    libxv
    libxvmc
    libsm
    libice
    libxshmfence
    libxcb
    libxcb-util
    libxcb-cursor
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxcb-wm
    libxkbcommon

    wayland
    wayland-protocols

    mesa
    libGL
    libGLU
    libglvnd
    vulkan-loader
    libdrm
    libgbm
    egl-wayland

    glib
    gtk2
    gtk3
    gtk4
    gdk-pixbuf
    atk
    at-spi2-core
    at-spi2-atk
    gsettings-desktop-schemas
    libsecret
    librsvg
    webkitgtk_4_1
    libsoup_3


    qt6.qtbase
    qt6.qtwayland
    qt5.qtbase
    qt5.qtwayland

    nss
    nspr
    cups
    dbus
    expat
    libxml2
    libxslt

    alsa-lib
    libpulseaudio
    pipewire
    libjack2

    ffmpeg
    libva
    libvdpau

    fuse
    fuse3

    udev
    libpng
    libjpeg
    libtiff
    libwebp
    json_c
    flac
    libogg
    libvorbis
    libtheora
    speex
    opusfile

    libnotify
    libxcrypt-legacy
  ];

  environment.systemPackages = [
    (pkgs.appimage-run.override {
      extraPkgs = pkgs: with pkgs; [
      stdenv.cc.cc.lib
      glibc
      zlib
      zstd
      bzip2
      xz
      lz4
      brotli
      libunwind
      attr
      acl
      libcap
      keyutils
      libuuid
      numactl
      systemd

      openssl
      curl
      libssh
      libssh2
      nghttp2
      c-ares
      gnutls
      libgcrypt
      libgpg-error
      krb5
      cyrus_sasl
      gsasl

      libarchive
      minizip

      fontconfig
      freetype
      harfbuzz
      fribidi
      icu
      libthai
      libdatrie
      pango
      cairo
      graphite2

      libx11
      libxext
      libxrender
      libxrandr
      libxcomposite
      libxdamage
      libxfixes
      libxtst
      libxi
      libxscrnsaver
      libxkbfile
      libxcursor
      libxinerama
      libxxf86vm
      libxmu
      libxpm
      libxt
      libxv
      libxvmc
      libsm
      libice
      libxshmfence
      libxcb
      libxcb-util
      libxcb-cursor
      libxcb-image
      libxcb-keysyms
      libxcb-render-util
      libxcb-wm
      libxkbcommon

      wayland
      wayland-protocols

      mesa
      libGL
      libGLU
      libglvnd
      vulkan-loader
      libdrm
      libgbm
      egl-wayland

      glib
      gtk2
      gtk3
      gtk4
      gdk-pixbuf
      atk
      at-spi2-core
      at-spi2-atk
      gsettings-desktop-schemas
      libsecret
      librsvg
      webkitgtk_4_1
      libsoup_3


      qt6.qtbase
      qt6.qtwayland
      qt5.qtbase
      qt5.qtwayland

      nss
      nspr
      cups
      dbus
      expat
      libxml2
      libxslt

      alsa-lib
      libpulseaudio
      pipewire
      libjack2

      ffmpeg
      libva
      libvdpau

      fuse
      fuse3

      udev
      libpng
      libjpeg
      libtiff
      libwebp
      json_c
      flac
      libogg
      libvorbis
      libtheora
      speex
      opusfile

      libnotify
      libxcrypt-legacy
      ];
    })
  ];
}
