#############################################################
#
#  HTPC - Homie Theatre
#
###############################################################

{
  inputs,
  lib,
  # pkgs,
  ...
}:
{
  imports = lib.flatten [
    #
    # ========== Hardware ==========
    #
    ./hardware-configuration.nix
    inputs.hardware.nixosModules.common-cpu-intel

    #
    # ========== Disk Layout ==========
    #
    inputs.disko.nixosModules.disko
    # TODO:: modify with the disko spec file you want to use.
    (lib.custom.relativeToRoot "hosts/common/disks/btrfs-disk.nix")
    # TODO: modify the options below to inform disko of the host's disk path and swap requirements.
    # IMPORTANT: nix-config-starter assumes a single disk per host. If you require more disks, you
    # must modify or create new disko specs.
    {
      _module.args = {
        disk = "/dev/nvme0n1";
        withSwap = true;
        swapSize = 16;
      };
    }

    (map lib.custom.relativeToRoot [
      #
      # ========== Required Configs ==========
      #
      "hosts/common/core"

      #
      # ========== Non-Primary Users to Create ==========
      #
      # The primary user, defined in `nix-config/hosts/common/users`, is added by default, via
      # `hosts/common/core` above.
      # To create additional users, specify the path to their config file, as shown in the commented line below, and create/modify
      # the specified file as required.

      "hosts/common/users/homie"

      #
      # ========== Optional Configs ==========
      #
      "hosts/common/optional/services/openssh.nix" # allow remote SSH access
      "hosts/common/optional/audio.nix" # pipewire and cli controls
      "hosts/common/optional/xfce.nix" # lightweight x-based window manager
    ])
  ];

  #
  # ========== Host Specification ==========
  #

  hostSpec = {
    hostName = "htpc";
    primaryDesktopUsername = "homie";
    primaryUser = "michael";
    users = [
      "michael"
      "homie"
    ];
  };

  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "homie";
  };

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  boot.loader = {
    systemd-boot = {
      enable = true;
      # When using plymouth, initrd can expand by a lot each time, so limit how many we keep around
      configurationLimit = lib.mkDefault 10;
    };
    efi.canTouchEfiVariables = true;
    timeout = 3;
  };

  boot.initrd = {
    systemd.enable = true;
  };

  hardware.graphics = {
    enable = true;
  };
  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";

}
