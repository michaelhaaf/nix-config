{ pkgs, ... }:
{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    xdg-desktop-portal
  ];

  # Fix waybar not launching outside of dbus-run-session.
  xdg.portal.enable = true;
}
