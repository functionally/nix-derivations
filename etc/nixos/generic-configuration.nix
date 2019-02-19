{ config, pkgs, ... } :

{

  hardware = {
    enableAllFirmware = true;
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
    bluetooth.enable = true;
  };

  powerManagement = {
    enable = true;
  # resumeCommands = ''
  #   ${pkgs.xfce.xfce4_power_manager}/bin/xfce4-power-manager
  # '';
  };

  boot.cleanTmpDir = true;

  nixpkgs.config.allowUnfree = true;

  networking = {

    domain = "lan";

    nameservers = [
    # Use `ip route` to find DNS on "Google Starbucks".
    # "172.31.98.1"
      "8.8.8.8"
      "8.8.4.4"
      "9.9.9.9"
      "1.1.1.1"
    ];

    extraHosts = ''
      192.168.86.42 gazelle
      192.168.86.23 lemur
      192.168.86.45 stick-1
      192.168.86.44 LS210DBB
      192.168.86.41 HPC68886
    # Use `ip route` to find DNS on "Google Starbucks".
    # 172.31.98.1 aruba.odyssys.net
    '';

    firewall = {
    # allowedTCPPorts = [ ... ];
    # allowedUDPPorts = [ ... ];
      extraCommands = ''
        iptables -I INPUT -p udp -s 192.168.0.0/16 --match multiport --dports 1900,5353 -m udp                           -j nixos-fw-accept # chromecast, see <https://github.com/NixOS/nixpkgs/issues/3107#issuecomment-377716548>
        iptables -I INPUT -p tcp                                     --dport   2181     -m state --state NEW,ESTABLISHED -j nixos-fw-accept # zookeeper
        iptables -I INPUT -p tcp                                     --dport   4001     -m state --state NEW,ESTABLISHED -j nixos-fw-accept # ipfs
        iptables -I INPUT -p tcp                                     --dport   5432     -m state --state NEW,ESTABLISHED -j nixos-fw-accept # postgresql
        iptables -I INPUT -p tcp                                     --dport   5820     -m state --state NEW,ESTABLISHED -j nixos-fw-accept # stardog
        iptables -I INPUT -p tcp                                     --dport   9092     -m state --state NEW,ESTABLISHED -j nixos-fw-accept # kafka
        iptables -I INPUT -p tcp                                     --dport  27017     -m state --state NEW,ESTABLISHED -j nixos-fw-accept # mongodb
        iptables -I INPUT -p tcp                                     --dport  32749     -m state --state NEW,ESTABLISHED -j nixos-fw-accept # gridcoinresearchd
      '';
    };

  };

  time.timeZone = "America/Denver";

  users.extraGroups = [
    {
      name = "plugdev"  ;
      gid  = 46         ;
    }
    {
      name = "rkt"      ;
      gid  = 98         ;
    }
    {
      name = "rkt-admin";
      gid  = 99         ;
    } 
  ];

  services = {

    upower.enable = true;

    udev.extraRules = ''
      # Oculus Go
      SUBSYSTEM=="usb", ATTR{idVendor}=="2833", ATTR{idProduct}=="0083", MODE="0666", GROUP="plugdev" OWNER="bbush"
      SUBSYSTEM=="usb", ATTR{idVendor}=="2833", ATTR{idProduct}=="0086", MODE="0666", GROUP="plugdev" OWNER="bbush"
      # Phab 2 Pro
      SUBSYSTEM=="usb", ATTR{idVendor}=="17ef", ATTR{idProduct}=="7a13", MODE="0666", GROUP="plugdev" OWNER="bbush"
      # Blink
      SUBSYSTEM=="usb", ATTR{idVendor}=="27b8", ATTR{idProduct}=="01ed", MODE="0666", GROUP="plugdev" OWNER="bbush"
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

    openssh.enable = true;

  };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
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

# virtualisation.virtualbox.host.enable

}
