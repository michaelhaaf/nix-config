{ lib, pkgs, ... }:
{
  home.packages = lib.attrValues {
    inherit (pkgs)
      # Device imaging
      rpi-imager

      # Productivity
      drawio
      libreoffice

      # Media production
      audacity
      gimp
      inkscape

      # RDP
      remmina
      # Temporarily don't build this because of OOM
      # rustdesk
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
