{ config, pkgs, pkgs-unstable, plasma-manager, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./FixFHS.nix
  ];

  ############################################################################
  # BOOT / KERNEL
  ############################################################################

  boot.kernelPackages = pkgs.linuxPackages;

  boot.initrd.availableKernelModules = [ "uas" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.blacklistedKernelModules = [ ];
  boot.kernelModules = [ "i2c-dev" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ ];
  hardware.firmware = with pkgs; [ linux-firmware ];
  hardware.enableRedistributableFirmware = true;
  hardware.i2c.enable = true;

  ############################################################################
  # GRAPHICS (AMD)
  ############################################################################

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  ############################################################################
  # SHELL (fish)
  ############################################################################

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  ############################################################################
  # LOCALE / TIME / KEYBOARD
  ############################################################################

  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "ru_RU.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us,ru";
    variant = ",";
  };

  ############################################################################
  # FONTS (SYSTEM)
  ############################################################################

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    liberation_ttf
    adwaita-fonts
    corefonts
  ];

  ############################################################################
  # DESKTOP ENVIRONMENT
  ############################################################################

  services.xserver.enable = false;
  hardware.bluetooth.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.printing.enable = true;
  services.fstrim.enable = true;   # SSD/NVMe MAINTENANCE

  programs.throne = {
    enable = true;
    tunMode.enable = true;
  };

  virtualisation.libvirtd.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    kwin-x11
    elisa
    okular
    khelpcenter
    baloo-widgets
    dolphin-plugins
    qrca
    discover
    kwrited
  ];

  ############################################################################
  # DDCUTIL
  ############################################################################

  users.groups.i2c = {};

  services.udev.extraRules = ''
    KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
'';

  ############################################################################
  # FLATPAK
  ############################################################################

  xdg.portal.enable = true;

  services.flatpak.enable = true;

  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    serviceConfig.Type = "oneshot";
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

  ############################################################################
  # AUDIO (PipeWire)
  ############################################################################

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  ############################################################################
  # USERS
  ############################################################################

  users.groups.nixuser = {};

  users.users."nixuser" = {
    isNormalUser = true;
    group = "nixuser";
    description = "nixuser";
    extraGroups = [ "networkmanager" "wheel" "i2c" "kvm" "libvirtd" "adbusers" ];
    packages = with pkgs; [ ];
  };

  ############################################################################
  # HOME-MANAGER / PLASMA-MANAGER
  ############################################################################

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users."nixuser" = { ... }: {
  imports = [ plasma-manager.homeModules.plasma-manager ];

  home.stateVersion = "26.05";

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/about" = "librewolf.desktop";
      "x-scheme-handler/unknown" = "librewolf.desktop";
    };
  };

  programs.plasma = {
    enable = true;

    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      colorScheme = "BreezeDark";
    };

    fonts = {
      general      = { family = "Noto Sans"; pointSize = 12; };
      fixedWidth   = { family = "Hack";      pointSize = 12; };
      small        = { family = "Noto Sans"; pointSize = 10; };
      toolbar      = { family = "Noto Sans"; pointSize = 12; };
      menu         = { family = "Noto Sans"; pointSize = 12; };
      windowTitle  = { family = "Noto Sans"; pointSize = 10; };
    };

    panels = [
      {
        location = "bottom";
        height = 44;
        floating = true;
        hiding = "dodgewindows";

        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.pager"
          {
            iconTasks.launchers = [
              "applications:systemsettings.desktop"
              "applications:org.kde.dolphin.desktop"
              "applications:org.kde.konsole.desktop"
              "applications:librewolf.desktop"
            ];
          }
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
    ];

    kscreenlocker = {
      lockOnResume = true;
      timeout = 20;
      autoLock = true;
    };

    configFile."ksmserverrc"."General"."loginMode" = "emptySession";
    configFile."kwinrc"."Effect-overview"."BorderActivate" = "";
    configFile."kdeglobals"."General"."AccentColorFromWallpaper" = true;
    configFile."baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
    configFile."kwalletrc"."Wallet"."Enabled" = false;
    configFile."kdeglobals"."General"."BrowserApplication" = "librewolf.desktop";
  };
};
  ############################################################################
  # FILESYSTEMS / MOUNTS
  ############################################################################

  fileSystems."/" = {
    fsType = "btrfs";
    options = [ "compress=zstd" "noatime" ];
  };

  ############################################################################
  # PACKAGES
  ############################################################################

  environment.systemPackages = with pkgs; [

    # base systemPackages
    git
    btop
    neovim
    scrcpy
    ffmpeg
    fastfetch
    android-tools
    dotnet-sdk_8
    ddcutil
    usbutils
    p7zip
    unrar
    qemu
    OVMF


    # DE Packages
    kdePackages.filelight
    gnome-sound-recorder
    gnome-disk-utility
    kdePackages.kcalc
    kdePackages.ark
    gnome-software
    resources
    localsend
    gapless
    darkly
    papers
    pinta
    throne

    # !! Пользовательские программы
    pkgs-unstable.kdePackages.kdenlive
    onlyoffice-desktopeditors
    pkgs-unstable.librewolf
    pkgs-unstable.chromium
    pkgs-unstable.gimp
    libreoffice-qt
    qbittorrent
    godot_4_7
    obsidian
    inkscape
    audacity
    blender
    freecad
    vscode
    reaper
    krita
    vlc

    # образовательное ПО
    #geogebra
    #stellarium
    #kicad

     кодеки
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav

  ];

  ############################################################################
  # ZRAM
  ############################################################################

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
    memoryMax = 2 * 1024 * 1024 * 1024;
    priority = 100;
  };

  ############################################################################
  # NIX GARBAGE COLLECTION
  ############################################################################

  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 14d";

  ############################################################################
  # NETWORKING
  ############################################################################

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  ############################################################################
  # SYSTEM / NIX
  ############################################################################

  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";
  nix.daemonIOSchedPriority = 7;

  nix.settings = {
    max-jobs = 2;
    cores = 4;
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
}
