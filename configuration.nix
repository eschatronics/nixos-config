# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      # <nixos-hardware/lenovo/thinkpad/x220> 
      ./hardware-configuration.nix
      <nixpkgs/nixos/modules/services/x11/window-managers/i3.nix>
      <nixpkgs/nixos/modules/services/networking/networkmanager.nix>
      <nixpkgs/nixos/modules/virtualisation/virtualbox-host.nix>
      <nixpkgs/nixos/modules/services/hardware/thinkfan.nix>
      <nixpkgs/nixos/modules/services/hardware/udev.nix>
    ];
 
  # nix.extraOptions = "
  #  gc-keep-outputs = true
  #  gc-keep-derivations = true
  # " ;
 
  boot.supportedFilesystems = [ "zfs" ];
  boot.cleanTmpDir = true;
  boot.initrd.kernelModules = [ "zfs" ];
  boot.kernelModules = [ "tp_smapi" "kvm-intel" "zfs" "vboxdrv" "vboxnetadp" "vboxpci" "vboxnetflt" ]; 
  
  boot.extraModulePackages = [
    pkgs.linuxPackages.virtualbox
  ];

  # boot.initrd.withExtraTools = true;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "wintermute"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  virtualisation.virtualbox.host = {
    enable = true;
    addNetworkInterface = true; 
  };
  services.virtualbox.host = {
    enable = true;
  };
  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "America/Halifax";

  networking.hostId = "deba5e12";
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
     wget 
     vim
     espeak
     emacs
     networkmanager
     firefox
     tmux
     git
     zathura
     roxterm
     xterm
     i3
     mlocate
     psmisc
     coreutils
     file
     nox
     virtualbox
     trezord
     tor
     hackrf
     mkpasswd
  ];


   
  # deprecated
  # security.setuidPrograms = [ "VirtualBox" "VBoxManage" ]; 

  nixpkgs.config = {
    allowUnfree = true;
  };
  
  services.syslogd.enable = true;
  services.trezord.enable = true;
  services.tor.enable = true;
  
## Add some udev rules for hackrf: 
  services.udev.extraRules = ''
ATTR{idVendor}=="1d50", ATTR{idProduct}=="6089", SYMLINK+="hackrf-one-%k", MODE="660", GROUP="plugdev"
  '';
  

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:
  services.thinkfan = {
    enable = true;
    sensor = "/sys/devices/virtual/hwmon/hwmon0/temp1_input";
  };
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  
  # X stuff
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    autorun = false;
    exportConfiguration = false;
    enableTCP = false;
    layout = "us";
    xkbOptions = "ctrl:swapcaps";
    libinput = { 
      enable = true;
      tapping = false;
    };
    displayManager = {
      lightdm.enable = true;
    };
    windowManager = {
      default = "i3";
      awesome.enable = true;
      i3 = {
        enable = true;
      };
    };
  };
  # Enable the X11 windowing system.

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.oblivia = {
    isNormalUser = true;
    uid = 1000;
    passwordFile = "./oblivia.passwd";
    extraGroups = [ "wheel" "networkmanager" "vboxusers" "cups" "radio" "pcap" ];
    group = "users";
    createHome = true;
  };
 
  # An empty user account, used only for testing purposes. 
  users.extraUsers.virgin = {
    isNormalUser = true;
    uid = 9999;
    passwordFile = "./virgin.passwd";
    group = "users";
    createHome = true;
  };
  
  security.sudo.wheelNeedsPassword = false;

  powerManagement.enable = false;
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?

   
  hardware.opengl.driSupport32Bit = true;

}
