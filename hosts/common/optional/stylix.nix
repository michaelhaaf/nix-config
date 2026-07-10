{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix = {
    enable = true;
    image = lib.custom.relativeToRoot "assets/wallpapers/pieter_bruegel_the_elder-the_tower_of_babel.jpg";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";
    opacity = {
      applications = 1.0;
      terminal = 0.95;
      desktop = 0.9;
      popups = 0.8;
    };
    polarity = "dark";
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Ice";
      size = 48;
    };
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.iosevka-term-slab;
        name = "IosevkaTermSlab NF";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.ubuntu-sans;
        name = "Ubuntu Nerd Font";
      };
      serif = {
        package = pkgs.et-book;
        name = "ETBembo";
      };
    };
  };
}
