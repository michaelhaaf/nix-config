{ lib, pkgs, ... }:
{

  home.packages = lib.attrValues {
    inherit (pkgs)
      signal-desktop
      # telegram-desktop # TODO: not working at the moment

      # matrix
      # cinny-desktop # TODO: this is marked broken at the moment
      iamb

      # discord
      vesktop
      ;
  };
}
