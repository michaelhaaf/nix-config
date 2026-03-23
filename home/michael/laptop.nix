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

  # ========== Host-specific Monitor Spec ==========
  #
  # This uses the nix-config/modules/home/montiors.nix module which defaults to enabled.
  # Your nix-config/home-manger/<user>/common/optional/desktops/foo.nix WM config should parse and apply these values to it's monitor settings
  #   ------   ------
  #  | DP-1 | | DP-2 |
  #   ------   ------
  monitors = [
    {
      name = "DP-1";
      width = 3840;
      height = 2160;
      refreshRate = 60;
      primary = true;
      x = 0;
      y = 0;
    }
    {
      name = "DP-2";
      width = 3840;
      height = 2160;
      refreshRate = 60;
      x = 3840;
      y = 0;
    }
  ];

}
