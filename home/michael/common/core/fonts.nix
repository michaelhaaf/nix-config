{ pkgs, ... }:
{
  home.packages = [
    pkgs.noto-fonts
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.iosevka
    pkgs.nerd-fonts.iosevka-term
    pkgs.nerd-fonts.iosevka-term-slab
    pkgs.nerd-fonts.ubuntu-sans
    pkgs.nerd-fonts.ubuntu
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "pkgs.nerd-fonts.iosevka-term-slab" ];
      sansSerif = [ "pkgs.nerd-fonts.ubuntu-sans" ];
      serif = [ "pkgs.nerd-fonts.ubuntu" ];
    };
  };
}
