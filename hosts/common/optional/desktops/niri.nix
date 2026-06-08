{
  inputs,
  config,
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

  # Prefer the noctalia polkit plugin for now
  systemd.user.services.niri-flake-polkit.enable = false;

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

  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      niri = {
        prettyName = "niri";
        comment = "Niri compositor managed by UWSM";
        binPath = pkgs.writeShellScript "niri" ''
          ${lib.getExe config.programs.niri.package}/bin/niri-session
        '';
      };
    };
  };
}
