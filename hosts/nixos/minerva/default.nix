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

      "hosts/common/optional/services/tailscale.nix"
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
    persistFolder = "/persist";
  };

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
    hostId = "763a41a9";
  };

  # Firmware update
  services.fwupd.enable = true;

  # Automatic scrubbing
  services.zfs.autoScrub.enable = true;

  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs = {
      forceImportRoot = false;
      extraPools = [ "tank" ];
    };
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        copyKernels = true;
        mirroredBoots = [
          {
            path = "/boot";
            devices = [ "/dev/disk/by-uuid/4A60-0A0F" ];
          }
          {
            path = "/boot-mirror";
            devices = [ "/dev/disk/by-uuid/4A60-6400" ];
          }
        ];
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
    # Uncomment after first reboot
    initrd.systemd = {
      enable = true;
      services.rollback = {
        description = "Rollback ZFS root subvolume to a pristine state";
        wantedBy = [ "initrd.target" ];

        # Before mounting the system root (/sysroot) during the early boot process
        before = [ "sysroot.mount" ];

        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";

        script = ''
          zfs rollback -r rpool/local/root@blank
        '';
      };
    };
  };

  fileSystems."/boot".options = [ "nofail" ];
  fileSystems."/boot-mirror".options = [ "nofail" ];

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
