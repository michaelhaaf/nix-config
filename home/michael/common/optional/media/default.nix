{ lib, pkgs, ... }:
{
  home.packages = lib.attrValues {
    inherit (pkgs)
      vlc
      mpv
      ffmpeg
      imagemagick
      jellyfin-desktop
      jellyfin-tui
      jellycli
      ;
  };
}
