{
  pkgs,
  ...
}:
{
  stylix.targets.rofi.enable = true;
  programs.rofi = {
    enable = true;
    pass = {
      enable = true;
      package = pkgs.rofi-pass-wayland;
    };
  };
}
