#############################################################
#
#  Genoa - Laptop
#  NixOS running on Lenovo Thinkpad E15
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

    <nixos-hardware/hp/elitebook/845/g8>
    ./hardware-configuration.nix

    #
    # ========== Disk Layout ==========
    #
    inputs.disko.nixosModules.disko
    (lib.custom.relativeToRoot "hosts/common/disks/btrfs-disk.nix")
    {
      _module.args = {
        disk = "/dev/nvme0n1";
        withSwap = true;
        swapSize = 16;
      };
    }

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
      # "hosts/common/optional/services/bluetooth.nix" # bluetooth, blueman and bluez via wireplumber
      # "hosts/common/optional/services/greetd.nix" # display manager
      # "hosts/common/optional/services/openssh.nix" # allow remote SSH access
      # "hosts/common/optional/services/printing.nix" # CUPS
      # "hosts/common/optional/audio.nix" # pipewire and cli controls
      # "hosts/common/optional/gaming.nix" # window manager
      # "hosts/common/optional/hyprland.nix" # window manager
      # "hosts/common/optional/nvtop.nix" # GPU monitor (not available in home-manager)
      # "hosts/common/optional/obsidian.nix" # wiki
      # "hosts/common/optional/plymouth.nix" # fancy boot screen
      # "hosts/common/optional/protonvpn.nix" # vpn
      # "hosts/common/optional/thunar.nix" # file manager
      # "hosts/common/optional/vlc.nix" # media player
      # "hosts/common/optional/wayland.nix" # wayland components and pkgs not available in home-manager
      # "hosts/common/optional/wifi.nix" # wayland components and pkgs not available in home-manager
      # "hosts/common/optional/yubikey.nix" # yubikey related packages and configs

      # TODO: these are the HTPC ones for now -- switch later when I do laptop stuff!
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
    hostName = "laptop";
    # TODO: remove when I'm no longer using as htpc
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
