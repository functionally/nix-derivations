{ config, pkgs, ... } :

{
  environment.systemPackages = with pkgs; [

    acpi
    apparmor-utils
    binutils
    btrfs-dedupe
  # busybox
    cifs-utils
    coreutils
    cryptsetup
    ddrescue
    efibootmgr
    exfat
    exfat-utils
    gnufdisk
    gptfdisk
  # linuxConsoleTools
    lsof
    lshw
    mkpasswd
    mtools
    parted
    patchelf
    patchutils
    pbzip2
    psmisc
    pv
    sshguard
    telnet
    traceroute
    tree
    unzip
    usbutils
    wget
    whois

    bluez
    bluez-tools
    cacert
    libu2f-host
    mmc-utils
    strongswan

    atop
    htop

    screen
    tmux
    vim

    git
    mercurial

  ];
}
