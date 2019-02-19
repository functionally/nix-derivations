{ config, pkgs, ... } :

{

  environment.systemPackages = with pkgs; [
    blueman
  # electricsheep
    pavucontrol
    xfce.xfce4_battery_plugin
    xfce.xfce4_cpufreq_plugin
    xfce.xfce4_cpugraph_plugin
    xfce.xfce4-hardware-monitor-plugin
    xfce.xfce4_power_manager
    xfce.xfce4-sensors-plugin
    xfce.gvfs
    xorg.xmodmap
    xscreensaver
  ];

  services.xserver = {

    enable = true;
    autorun = true;

  # layout = "us";
  # xkbOptions = "eurosign:e";

  # libinput.enable = true;
    synaptics = {
      enable = true;
    };
    wacom = {
      enable = true;
    };

    desktopManager.xfce = {
      enable = true;
    };

    displayManager.lightdm = {
      enable = true;
    };

  # desktopManager.plasma5.enable = true;
  # displayManager.sddm.enable = true;
  # windowManager.twm.enable = true;

  };

}
