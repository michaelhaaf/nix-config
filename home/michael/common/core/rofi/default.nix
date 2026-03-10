{
  pkgs,
  ...
}:
{
  stylix.targets.rofi.enable = true;
  xdg.configFile."rofi-pass/rofi-pass.rasi".source = ./rofi-pass.rasi;
  programs.rofi = {
    enable = true;
    pass = {
      enable = true;
      package = pkgs.rofi-pass-wayland;
    };
  };
}
