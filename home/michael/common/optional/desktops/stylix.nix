{ config, lib, ... }:
{
  config = lib.mkIf (config ? "stylix") {
    stylix.targets = {
      ghostty.enable = true;
      wezterm.enable = true;
      kitty.enable = true;
      btop.enable = true;
    };
  };
}
