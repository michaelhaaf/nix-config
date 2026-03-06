{ lib, pkgs, ... }:
{
  home.packages = lib.attrValues {
    inherit (pkgs)
      vlc
      mpv
      ffmpeg
      jellyfin-desktop
      jellyfin-tui
      jellycli
      ;
  };
}
