{ config, pkgs, ... } :

{
  environment.systemPackages = with pkgs; [

    acpi
    apparmor-utils
    binutils
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
  # nethogs
    parted
    patchelf
    patchutils
    pinentry
    pinentry-curses
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
    openvpn
  # strongswan

    atop
    htop

    screen
    tmux
    vim

    git
    mercurial

    # For Trezor, per <https://wiki.trezor.io/Apps:SSH_agent#Setup_.28NixOS.29>.
    gnupg
  # pinentry
    (python3.withPackages(ps: with ps; [ trezor_agent wheel]))

  ];
}
