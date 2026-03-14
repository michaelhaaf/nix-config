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

      "hosts/common/optional/stylix.nix" # host-wide styling

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
    # useYubikey = lib.mkForce true;
    # hdr = lib.mkForce true;
    persistFolder = "/persist"; # added for "completion" because of the disko spec that was used even though impermanence isn't actually enabled here yet.
  };

  # set custom autologin options. see greetd.nix for details
  #  autoLogin.enable = true;
  #  autoLogin.username = config.hostSpec.username;
  #
  #  services.gnome.gnome-keyring.enable = true;

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
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
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };
    initrd = {
      systemd.enable = true;
    };
    kernelPackages = pkgs.unstable.linuxPackages_latest;
  };

  # needed to unlock LUKS on secondary drives
  # use partition UUID
  # https://wiki.nixos.org/wiki/Full_Disk_Encryption#Unlocking_secondary_drives
  # environment.etc.crypttab.text = lib.optionalString (!config.hostSpec.isMinimal) ''
  #   cryptextra UUID=d90345b2-6673-4f8e-a5ef-dc764958ea14 /luks-secondary-unlock.key
  #   cryptvms UUID=ce5f47f8-d5df-4c96-b2a8-766384780a91 /luks-secondary-unlock.key
  # '';

  hardware = {
    graphics = {
      enable = true;
      package = lib.mkForce pkgs.unstable.mesa.drivers;
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

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
