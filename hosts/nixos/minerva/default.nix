#############################################################
#
#  Minerva - Homelab Server
#  NixOS running on Ryzen 5 5600G, 32GB RAM
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
    # USING imperative shell to initialize disk layout for ZFS
    # see TODO: an explainer

    #
    # ========== Misc Inputs ==========
    #

    (map lib.custom.relativeToRoot [
      #
      # ========== Required Configs ==========
      #
      "hosts/common/core"

      #
      # ========== Optional Configs ==========
      #

    ])

  ];

  #
  # ========== Host Specification ==========
  #

  hostSpec = {
    hostName = "minerva";
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

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
    # TODO:
    hostId = "fcb8db9f";
  };

  # Firmware update
  services.fwupd.enable = true;

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
    zfs.forceImportRoot = false;
  };

  hardware = {
    graphics = {
      enable = true;
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
