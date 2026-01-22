{ pkgs, ... }:
{
  imports = [
    #################### Required Configs ####################
    common/core # required

    #################### Host-specific Optional Configs ####################
  ];

  # Packages without declaritive configuration
  home.packages = builtins.attrValues {
    inherit (pkgs)
      vlc
      ;
  };
}
