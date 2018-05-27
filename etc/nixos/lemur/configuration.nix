{ config, pkgs, ... }:

{

  imports = [
    ./hardware-configuration.nix
    ./generic-configuration.nix
    ./system-packages.nix
    ./desktop-packages.nix
    ./vpn-configuration.nix
    ./users-groups.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub.device = "/dev/nvme0n1p1";
    };
    initrd.luks.devices = [
      {
        name = "main";
        device = "/dev/nvme0n1p2";
        preLVM = true;
      }
    ];
  };

  fileSystems = {
    "/data" = {
      device = "/dev/vgmain/user";
      fsType = "btrfs";
      options = [ "subvol=@data" "compress=lzo" ];
    };
    "/home" = {
      device = "/dev/vgmain/user";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zlib" ];
    };
    "/scratch" = {
      device = "/dev/vgmain/user";
      fsType = "btrfs";
      options = [ "subvol=@scratch" "compress=zlib" ];
    };
  };

  networking = {
    hostId = "ef20b03b";
    hostName = "lemur";
    networkmanager.enable = true;
  # wireless.enable = true;  # Enables wireless support via wpa_supplicant.  
  };

  environment.systemPackages = with pkgs; [
    efibootmgr
  ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "18.03";

}
