{ lib, ... }:
{
  imports = [
    #
    # ========== Required Configs ==========
    #
    common/core

    #
    # ========== Host-specific Optional Configs ==========
    #
    common/optional/desktops/niri

    common/optional/sops.nix
    common/optional/desktops
    common/optional/shell-extras
    common/optional/development
    common/optional/comms
    common/optional/media
    common/optional/tools
  ]
  ++ map lib.custom.relativeToRoot [
    "home/common/optional/browsers/firefox.nix"
    "home/common/optional/browsers/librewolf.nix"
  ];

  # TODO: this module isn't being loaded for some reason.
  # services.yubikey-touch-detector.enable = true;
  # services.yubikey-touch-detector.notificationSound = true;
  #
  # TODO: this module isn't being loaded for some reason.
  # ========== Host-specific Monitor Spec ==========
  #
  # This uses the nix-config/modules/home/montiors.nix module which defaults to enabled.
  # Your nix-config/home-manger/<user>/common/optional/desktops/foo.nix WM config should parse and apply these values to it's monitor settings
  #   ------     ------
  #  | DP-3 | | HDMI-A-1 |
  #   ------     ------
  monitors = [
    {
      name = "DP-3";
      width = 1920;
      height = 1080;
      refreshRate = 60;
      x = -1920;
      y = 320;
    }
    {
      name = "HDMI-A-1";
      width = 2560;
      height = 1440;
      refreshRate = 60;
      primary = true;
    }
  ];
}
