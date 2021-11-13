{ config, pkgs, ... } :

{

  hardware = {
    system76.enableAll = true;
    enableAllFirmware = true;
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
    bluetooth.enable = true;
    ledger.enable = true;
  };

  sound.enable = true;

  powerManagement = {
    enable = true;
####    resumeCommands = ''
####      ${pkgs.xfce.xfce4_power_manager}/bin/xfce4-power-manager
####    '';
  };

  boot.cleanTmpDir = true;

  nixpkgs.config.allowUnfree = true;

  networking = {

    domain = "lan";

    nameservers = [
    # Use `ip route` to find DNS on "Google Starbucks".
    # "172.31.98.1"
    # Visit <https://wifi.starbucks.com> or <https://sbux-portal.globalreachtech.com>.
      "8.8.8.8"
      "1.1.1.1"
      "8.8.4.4"
      "9.9.9.9"
    ];

    extraHosts = ''
      192.168.0.6     nuc
      192.168.0.7     gazelle
      192.168.0.7     textile.brianwbush.info
      192.168.86.23   lemur-wifi
      192.168.86.42   gazelle-wifi
      192.168.86.52   oryx-wifi
      192.168.86.44   nas
      172.31.98.1     aruba.odyssys.net
      103.103.192.105 dancomputer
    '';

    firewall = {
    # allowedTCPPorts = [ ... ];
    # allowedUDPPorts = [ ... ];
      extraCommands = ''

      # iptables -I INPUT -s 71.218.109.133  -j nixos-fw-accept # gazelle.bwbush.io
        iptables -I INPUT -s 104.198.152.159 -j nixos-fw-accept # substrate.functionally.dev
        iptables -I INPUT -s 192.168.0.6     -j nixos-fw-accept # nuc
        iptables -I INPUT -s 192.168.0.7     -j nixos-fw-accept # gazelle
        iptables -I INPUT -s 192.168.86.23   -j nixos-fw-accept # lemur-wifi
        iptables -I INPUT -s 192.168.86.42   -j nixos-fw-accept # gazelle-wifi

        iptables -I INPUT -p udp -s 192.168.0.0/16 --match multiport --dports 1900,5353 -m udp -j nixos-fw-accept # chromecast, see <https://github.com/NixOS/nixpkgs/issues/3107#issuecomment-377716548>

        iptables -I INPUT -p tcp --dport  2181 -m state --state NEW,ESTABLISHED -j nixos-fw-accept # zookeeper
        iptables -I INPUT -p tcp --dport  4001 -m state --state NEW,ESTABLISHED -j nixos-fw-accept # ipfs
        iptables -I INPUT -p tcp --dport  5050 -m state --state NEW,ESTABLISHED -j nixos-fw-accept # textile gateway
        iptables -I INPUT -p tcp --dport  5432 -m state --state NEW,ESTABLISHED -j nixos-fw-accept # postgresql
        iptables -I INPUT -p tcp --dport  5820 -m state --state NEW,ESTABLISHED -j nixos-fw-accept # stardog
        iptables -I INPUT -p tcp --dport  9092 -m state --state NEW,ESTABLISHED -j nixos-fw-accept # kafka
        iptables -I INPUT -p tcp --dport 10022 -m state --state NEW,ESTABLISHED -j nixos-fw-accept # ssh
        iptables -I INPUT -p tcp --dport 14348 -m state --state NEW,ESTABLISHED -j nixos-fw-accept # textile swarm
        iptables -I INPUT -p tcp --dport 19429 -m state --state NEW,ESTABLISHED -j nixos-fw-accept # textile swarm
        iptables -I INPUT -p tcp --dport 27017 -m state --state NEW,ESTABLISHED -j nixos-fw-accept # mongodb
        iptables -I INPUT -p tcp --dport 27663 -m state --state NEW,ESTABLISHED -j nixos-fw-accept # textile swarm
      # iptables -I INPUT -p tcp --dport 32749 -m state --state NEW,ESTABLISHED -j nixos-fw-accept # gridcoinresearchd
        iptables -I INPUT -p tcp --dport 40601 -m state --state NEW,ESTABLISHED -j nixos-fw-accept # textile cafe
        iptables -I INPUT -p tcp --dport 42042 -m state --state NEW,ESTABLISHED -j nixos-fw-accept # infovis

      '';
    };

  };

  time.timeZone = "America/Denver";

  users.extraGroups = {
    plugdev = {
      gid  = 46;
    };
    rkt = {
      gid  = 98;
    };
    rkt-admin = {
      gid  = 99;
    };
  };

  services = {

    upower.enable = true;

    udev.packages = [
      pkgs.ledger-udev-rules
      pkgs.trezor-udev-rules
    # pkgs.android-udev-rules
    ];

    udev.extraRules = ''

      # Oculus Go
      SUBSYSTEM=="usb", ATTR{idVendor}=="2833", ATTR{idProduct}=="0083", MODE="0666", GROUP="plugdev", OWNER="bbush"
      SUBSYSTEM=="usb", ATTR{idVendor}=="2833", ATTR{idProduct}=="0086", MODE="0666", GROUP="plugdev", OWNER="bbush"

      # Oculus Quest
      SUBSYSTEM=="usb", ATTR{idVendor}=="2833", ATTR{idProduct}=="0137", MODE="0666", GROUP="plugdev", OWNER="bbush"
      SUBSYSTEM=="usb", ATTR{idVendor}=="2833", ATTR{idProduct}=="0182", MODE="0666", GROUP="plugdev", OWNER="bbush"
      SUBSYSTEM=="usb", ATTR{idVendor}=="2833", ATTR{idProduct}=="0186", MODE="0666", GROUP="plugdev", OWNER="bbush"

      # Phab 2 Pro
      SUBSYSTEM=="usb", ATTR{idVendor}=="17ef", ATTR{idProduct}=="7a13", MODE="0666", GROUP="plugdev", OWNER="bbush"

      # Blink
      SUBSYSTEM=="usb", ATTR{idVendor}=="27b8", ATTR{idProduct}=="01ed", MODE="0666", GROUP="plugdev", OWNER="bbush"

#     # Ledger Nano X
#     SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="4015", TAG+="uaccess", TAG+="udev-acl", MODE="0666", GROUP="plugdev", OWNER="bbush"
#     KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0004", MODE="0666", GROUP="plugdev", OWNER="bbush"
#     KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0004"

      # Yubico usb key (Yubico Security Key by Yubico)
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0120", MODE="0666", TAG+="uaccess"

      # Feitan bluetooth key
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="096e", ATTRS{idProduct}=="085a", MODE="0666", TAG+="uaccess"

      # Titan bluetooth key (FS ePass FIDO)
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="096e", ATTRS{idProduct}=="085b", MODE="0666", TAG+="uaccess"

      # Titan usb key (FT U2F)
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="096e", ATTRS{idProduct}=="0858", MODE="0666", TAG+="uaccess"

      # Space Navigator
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c626", MODE="0664", GROUP="plugdev", SYMLINK+="input/spacenavigator"
    '';

    printing = {
      enable = true;
      drivers = [ pkgs.hplip pkgs.epson-escpr ];
    };

    openssh = {
      enable = true;
      allowSFTP = false;
      extraConfig = ''
        HostCertificate   /etc/ssh/ssh_host_rsa_key-cert.pub
        HostCertificate   /etc/ssh/ssh_host_ed25519_key-cert.pub
        TrustedUserCAKeys /etc/ssh/brianwbush-ca.pub
      '';
    };

    keybase.enable = false;

  # kbfs = {
  #   enable = false;
  #   extraFlags = [
  #     "-label kbfs"
  #     "-mount-type normal"
  #   ];
  #   mountPoint = "/data/keybase";
  # };

    trezord.enable = true;

    pcscd = {
      enable  = false;
      plugins = [ pkgs.ccid ];
    };

    clamav.daemon.enable = false;

  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  console = {
    font   = "Lat2-Terminus16";
    keyMap = "us";
  };

# fonts = {
#   enableFontDir = true;
#   enableGhostscriptFonts = true;
#   fonts = with pkgs; [
#     corefonts
#     inconsolata
#     lato
#     symbola
#     ubuntu_font_family
#     unifont
#     vistafonts
#   ];
# }; 

  # Some programs need SUID wrappers, can be configured further or are started in user sessions.
  programs = {
    bash.enableCompletion = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    mtr.enable = true;
  };

  security.chromiumSuidSandbox.enable = true;

  virtualisation.virtualbox.host.enable = false;

}
