{ lib, pkgs, ... }:
{
  imports = lib.custom.scanPaths ./.;
  home.packages = lib.attrValues {
    inherit (pkgs)
      signal-desktop
      vesktop
      teams-for-linux
      ;
  };
}
