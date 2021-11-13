# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/054b5a8c-76e0-4e92-a8b5-7f230ed6b401";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/D6E1-C064";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/cad65d78-cc2d-44c7-b29e-76e3043cd84a"; }
    ];

  nix.maxJobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
