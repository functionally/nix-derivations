{ config, pkgs, ... }:

{

  imports = [
    ./hardware-configuration.nix
    ./generic-configuration.nix
    ./system-packages.nix
  # ./desktop-packages.nix
  # ./vpn-configuration.nix
    ./users-groups.nix
  ];

  boot = {
    loader = {
      grub = {
        enable = true;
        version = 2;
        device = "/dev/sda"; # or "nodev" for efi only
      # efiSupport = true;
      # efiInstallAsRemovable = true;
      };
    # efi.efiSysMountPoint = "/boot/efi";
    };
  };

# powerManagement.enable = false;

  networking = {
    hostId = "3a576886";
    hostName = "gazelle";
  # networkmanager.enable = true;
    wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  };

  services = {
    logind.lidSwitch = "ignore";
    xserver.videoDrivers = [ "nvidia" ];
  };

  virtualisation.virtualbox.host.enable = false;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

}
