{ config, pkgs, ... } :

{
  environment.systemPackages = with pkgs; [

    acpi
  # at
  # apparmor-utils
    binutils
    btrfs-dedupe
    cifs-utils
    coreutils
  # cron
    cryptsetup
    ddrescue
    efibootmgr
    exfat
    exfat-utils
    gnufdisk
    gptfdisk
  # linuxConsoleTools
    lsof
  # lshw
    mkpasswd
    mtools
    parted
    patchelf
    patchutils
    pbzip2
    psmisc
    sshguard
    telnet
    traceroute
    unzip
    usbutils
    wget
    whois
  # wput

    bluez
    bluez-tools
    cacert
#   dbus
    libu2f-host
    mmc-utils
    strongswan
#   upower
  # vrpn

    atop
    htop

    screen
    tmux
    vim

    git
    mercurial

  # acbuild
  # rkt

  ];
}
