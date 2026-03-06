{ lib, pkgs, ... }:
{

  home.packages = lib.attrValues {
    inherit (pkgs)
      signal-desktop
      telegram-desktop

      # matrix
      cinny-desktop
      iamb

      # discord
      vesktop
      ;
  };
}
