#############################################################
#
#  HTPC - Homie Theatre
#
###############################################################

{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = lib.flatten [
    #
    # ========== Hardware ==========
    #
    ./hardware-configuration.nix
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.hardware.nixosModules.dell-latitude-7490

    #
    # ========== Disk Layout ==========
    # #
    # inputs.disko.nixosModules.disko
    # (lib.custom.relativeToRoot "hosts/common/disks/btrfs-disk.nix")
    # {
    #   _module.args = {
    #     disk = "/dev/sda";
    #     withSwap = true;
    #     swapSize = 8;
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
      "hosts/common/optional/services/bluetooth.nix"
      "hosts/common/optional/audio.nix" # pipewire and cli controls
      "hosts/common/optional/plasma.nix" # KDE desktop
      "hosts/common/optional/wayland.nix" # common wayland options
      "hosts/common/optional/wifi.nix" # common wifi options
      "hosts/common/optional/gaming.nix"
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

  # TODO: move this stuff to separate file but define theme itself per host
  # host-wide styling
  stylix = {
    enable = true;
    image = (lib.custom.relativeToRoot "assets/wallpapers/zen-01.png");
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";
    opacity = {
      applications = 1.0;
      terminal = 1.0;
      desktop = 1.0;
      popups = 0.8;
    };
    polarity = "dark";
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";

}
