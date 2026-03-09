{ pkgs, lib, ... }:
{
  imports = [
    #################### Required Configs ####################
    common/core # required

    #################### Host-specific Optional Configs ####################
  ]
  ++ map lib.custom.relativeToRoot [
    "home/common/optional/browsers/firefox.nix"
  ];

  # Packages without declarative configuration
  home.packages = builtins.attrValues {
    inherit (pkgs)
      vlc
      mpv
      ;
  };
}
