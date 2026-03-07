{ lib, pkgs, ... }:
{

  home.packages = lib.attrValues {
    inherit (pkgs)
      signal-desktop
      telegram-desktop

      # matrix
      # cinny-desktop # TODO: this is marked broken at the moment
      iamb

      # discord
      vesktop
      ;
  };
}
