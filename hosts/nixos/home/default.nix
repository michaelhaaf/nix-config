#############################################################
#
#  Home - Main Desktop
#  NixOS running on Ryzen 7 7700X, Radeon RX 6800, 64GB RAM
#
###############################################################

{
  inputs,
  lib,
  # config,
  pkgs,
  ...
}:
{
  imports = lib.flatten [
    #
    # ========== Hardware ==========
    #
    ./hardware-configuration.nix
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    #
    # ========== Disk Layout ==========
    #
    # USING shell instead of disko for layout for ZFS
    # inputs.disko.nixosModules.disko
    # (lib.custom.relativeToRoot "hosts/common/disks/home.nix")

    #
    # ========== Misc Inputs ==========
    #
    inputs.stylix.nixosModules.stylix

    (map lib.custom.relativeToRoot [
      #
      # ========== Required Configs ==========
      #
      "hosts/common/core"

      #
      # ========== Optional Configs ==========
      #
      "hosts/common/optional/desktops/niri.nix"

      "hosts/common/optional/services/greetd.nix" # display manager
      "hosts/common/optional/services/printing.nix" # CUPS
      "hosts/common/optional/services/openssh.nix" # allow remote SSH access
      "hosts/common/optional/services/bluetooth.nix" # bluetooth
      "hosts/common/optional/services/openrgb.nix" # openrgb
      "hosts/common/optional/services/tailscale.nix"

      "hosts/common/optional/amd.nix" # GPU monitor (not available in home-manager)
      "hosts/common/optional/libvirt.nix" # Virtual machine manager
      "hosts/common/optional/nvtop.nix" # GPU monitor (not available in home-manager)
      "hosts/common/optional/plymouth.nix" # fancy boot screen
      "hosts/common/optional/thunar.nix" # file manager
      "hosts/common/optional/audio.nix" # pipewire and cli controls
      "hosts/common/optional/wayland.nix" # common wayland options
      "hosts/common/optional/wifi.nix" # common wifi options
      "hosts/common/optional/gaming.nix" # steam and gamemode and stuff
      "hosts/common/optional/wine.nix" # run windows applications
      "hosts/common/optional/xdg.nix" # XDG spec modifications

      "hosts/common/optional/stylix.nix" # host-wide styling
      "hosts/common/optional/nix-ld.nix"

    ])

  ];

  #
  # ========== Host Specification ==========
  #

  hostSpec = {
    hostName = "home";
    primaryUser = "michael";
    users = [
      "michael"
    ];
    # TODO: set up yubikey
    # useYubikey = lib.mkForce true;
    # TODO: see if gpu/monitor support HDR
    # hdr = lib.mkForce true;
    persistFolder = "/persist";
  };

  # set custom autologin options. see greetd.nix for details
  #  autoLogin.enable = true;
  #  autoLogin.username = config.hostSpec.username;
  #
  #  services.gnome.gnome-keyring.enable = true;

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
    hostId = "fcb8db9f";
  };

  # Firmware update
  services.fwupd.enable = true;

  #FIXME(clamav): something not working. disabled to reduce log spam
  # semi-active-av.enable = false;

  # services.backup = {
  #   enable = true;
  #   borgBackupStartTime = "02:00:00";
  #   borgServer = "${config.hostSpec.networking.subnets.grove.hosts.oops.ip}";
  #   borgUser = "${config.hostSpec.username}";
  #   borgPort = "${builtins.toString config.hostSpec.networking.ports.tcp.oops}";
  #   borgBackupPath = "/var/services/homes/${config.hostSpec.username}/backups";
  #   borgNotifyFrom = "${config.hostSpec.email.notifier}";
  #   borgNotifyTo = "${config.hostSpec.email.backup}";
  # };

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        # When using plymouth, initrd can expand by a lot each time, so limit how many we keep around
        configurationLimit = lib.mkDefault 10;
      };
      efi = {
        efiSysMountPoint = "/boot/efi";
        canTouchEfiVariables = true;
      };
      timeout = 3;
    };
    initrd = {
      systemd.enable = true;
      # Uncomment after first reboot
      # postMountCommands = lib.mkAfter ''
      #   zfs rollback -r rpool/local/root@blank
      # '';
    };
    supportedFilesystems = [ "zfs" ];
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true; # for 32 bit programs like Wine
      # TODO: why unstable mesa? look at options
      package = lib.mkForce pkgs.unstable.mesa;
    };
    amdgpu = {
      initrd.enable = true; # load amdgpu kernelModules in stage 1.
      opencl.enable = true; # OpenCL support - general compute API for gpu
    };
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      clinfo # opencl testing
      vulkan-tools # vulkaninfo
      ;
  };

  services.lact.enable = true;

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
