{
  pkgs,
  lib,
  ...
}:
{
  xdg.configFile."rofi-pass/rofi-pass.rasi".source = ./rofi-pass.rasi;
  programs.rofi = {
    enable = true;
    theme = lib.mkDefault "~/.nix-profile/share/rofi/themes/Arc-Dark";
    font = lib.mkDefault "IosevkaTermSlab NF 16";
    pass = {
      enable = true;
      package = pkgs.rofi-pass-wayland;
    };
  };
}
