{ config, lib, ... }:
{
  config = lib.mkIf (config ? "stylix") {
    stylix.targets = {
      wezterm.enable = true;
      kitty.enable = true;
      btop.enable = true;
    };
  };
}
