{ config, pkgs, ... }:

{

  imports = [
    ./hardware-configuration.nix
    ./generic-configuration.nix
    ./system-packages.nix
    ./desktop-packages.nix
  # ./vpn-configuration.nix
    ./users-groups.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub = {
        device = "/dev/nvme0n1p1";
        efiSupport = true;
        memtest86.enable = true;
      };
    };
    initrd.luks.devices = {
      main = {
        device = "/dev/nvme0n1p2";
        preLVM = true;
      };
    };
    kernel.sysctl={
      "net.core.rmem_max" = 2500000;
    };
  };

  fileSystems = {
    "/data" = {
      device = "/dev/vgmain/user";
      fsType = "btrfs";
      options = [ "subvol=@data" "compress=zstd" ];
    };
    "/home" = {
      device = "/dev/vgmain/user";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd" ];
    };
    "/scratch" = {
      device = "/dev/vgmain/user";
      fsType = "btrfs";
      options = [ "subvol=@scratch" "compress=zstd" ];
    };
    "/extra" = {
      device = "/dev/vgmain/extra";
      fsType = "btrfs";
      options = [ "subvol=@extra" "compress=zstd" ];
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

  virtualisation.docker.enable = false;

  nix = {
    binaryCaches          = [ "https://hydra.iohk.io" "https://iohk.cachix.org" ];
    binaryCachePublicKeys = [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo=" ];
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "20.03";

}
