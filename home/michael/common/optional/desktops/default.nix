{ pkgs, ... }:
{
  imports = [
    ########## Utilities ##########
    ./gtk.nix
    ./playerctl.nix
    ./stylix.nix
  ];
  home.packages = [
    pkgs.pavucontrol # gui for pulseaudio server and volume controls
    pkgs.galculator # gtk based calculator
  ];
}
