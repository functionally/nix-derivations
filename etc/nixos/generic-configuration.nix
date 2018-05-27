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
    '';

    firewall = {
    # allowedTCPPorts = [ ... ];
    # allowedUDPPorts = [ ... ];
      extraCommands = ''
        #  Formerly for chromecast, see <https://github.com/NixOS/nixpkgs/issues/3107#issue-36677896>.
        iptables -I INPUT -p udp -m udp --dport 32768:61000 -j nixos-fw-accept
        # For chromecast, see <https://github.com/NixOS/nixpkgs/issues/3107#issuecomment-377716548>.
        iptables -I INPUT -p udp -m udp -s 192.168.0.0/16 --match multiport --dports 1900,5353 -j ACCEPT 
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
      SUBSYSTEM=="usb", ATTR{idVendor}=="27b8", ATTR{idProduct}=="01ed", MODE="0666", GROUP="plugdev" OWNER="bbush"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0120", MODE="0666", TAG+="uaccess"
      KERNEL=="event[0-9]*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c626", MODE="0664", GROUP="plugdev", SYMLINK+="input/spacenavigator"
    '';

    printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
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
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

}
