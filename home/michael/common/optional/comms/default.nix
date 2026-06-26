{ lib, pkgs, ... }:
{
  imports = lib.custom.scanPaths ./.;
  home.packages = lib.attrValues {
    inherit (pkgs.stable)
      signal-desktop
      vesktop
      teams-for-linux
      tor-browser
      element-desktop
      ;
  };
}
