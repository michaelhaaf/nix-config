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
  ];

}
