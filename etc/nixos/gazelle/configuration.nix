{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ./generic-configuration.nix
    ./system-packages.nix
  # ./desktop-packages.nix
  # ./vpn-configuration.nix
    ./users-groups.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking = {
    hostId = "3a576886";
    hostName = "gazelle";
  # networkmanager.enable = true;
    wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  };
  networking.useDHCP = false;
  networking.interfaces.enp3s0f0.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;

# powerManagement.enable = false;

  services = {
    logind.lidSwitch = "ignore";
    xserver.videoDrivers = [ "nvidia" ];
  };

  virtualisation.virtualbox.host.enable = false;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}

