#############################################################
#
#  Laptop
#  NixOS running on HP Elitebook 845 G8
#
###############################################################

{
  inputs,
  lib,
  ...
}:
{
  imports = lib.flatten [
    #
    # ========== Hardware ==========
    #

    inputs.hardware.nixosModules.hp-elitebook-845g8
    ./hardware-configuration.nix

    #
    # ========== Disk Layout ==========
    #
    # inputs.disko.nixosModules.disko
    # (lib.custom.relativeToRoot "hosts/common/disks/btrfs-disk.nix")
    # {
    #   _module.args = {
    #     disk = "/dev/nvme0n1";
    #     withSwap = true;
    #     swapSize = 16;
    #   };
    # }

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
      "hosts/common/optional/services/power.nix" # bluetooth

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
      "hosts/common/optional/vnc.nix" # VNC client programs
      "hosts/common/optional/torrenting.nix"
      "hosts/common/optional/stylix.nix"

      # "hosts/common/optional/yubikey.nix" # yubikey related packages and configs
    ])
  ];

  #
  # ========== Host Specification ==========
  #

  hostSpec = {
    hostName = "laptop";
    primaryUser = "michael";
    users = [
      "michael"
    ];
  };

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  # Firmware update
  services.fwupd.enable = true;

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
  system.stateVersion = "25.11";
}
