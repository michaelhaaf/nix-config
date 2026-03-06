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
      rustdesk
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
