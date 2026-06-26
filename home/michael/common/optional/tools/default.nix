{ lib, pkgs, ... }:
{
  home.packages = lib.attrValues {
    inherit (pkgs)
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
      inkscape

      # RDP
      remmina
      rustdesk

      yt-dlp
      ;

    inherit (pkgs.unstable)
      obs-studio
      grimblast # screenshot tool
      ;
    inherit (pkgs.unstable.pkgsRocm)
      blender
      ;
  };

}
