{ lib, pkgs, ... }:
{
  home.packages = lib.attrValues {
    inherit (pkgs.stable)
      # Device imaging
      rpi-imager

      # E-book client
      calibre

      # Productivity
      drawio
      libreoffice

      # Media production
      audacity
      gimp

      # RDP
      remmina

      # Other
      anki
      yt-dlp

      ;

    inherit (pkgs.unstable)
      obs-studio
      ;
    inherit (pkgs.unstable.pkgsRocm)
      blender
      ;
  };

}
