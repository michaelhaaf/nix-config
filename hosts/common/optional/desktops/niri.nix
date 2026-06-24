{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  nixpkgs.overlays = [ inputs.niri-flake.overlays.niri ];
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };
  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    xwayland-satellite
    xdg-desktop-portal-gtk
  ];

  # Calendar integration
  services.gnome.evolution-data-server.enable = true;

  # TODO:
  # I used to be using the noctalia polkit plugin, but I've moved back to this for now
  systemd.user.services.niri-flake-polkit.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    wlr.enable = true;
    config.common.default = lib.mkDefault [
      "gtk"
      "gnome"
    ];
    config.niri.default = lib.mkDefault [
      "gtk"
      "gnome"
    ];
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  i18n.inputMethod = {
    enable = true;
    type = "ibus";
  };

}
