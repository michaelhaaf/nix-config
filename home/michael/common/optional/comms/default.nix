{ lib, pkgs, ... }:
{

  home.packages = lib.attrValues {
    inherit (pkgs)
      signal-desktop
      vesktop
      ;
  };
}
