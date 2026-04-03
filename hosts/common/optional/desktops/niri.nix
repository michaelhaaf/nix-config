{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.niri = {
    enable = true;
    package = pkgs.unstable.niri;
  };
  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    xwayland-satellite
    xdg-desktop-portal-gtk

    # TODO: github.com/niri-wm/niri/issues/544
    # see the comment about replacing -gnome with -wlr
    xdg-desktop-portal-gnome
    gnome-keyring
  ];

  # Calendar integration
  services.gnome.evolution-data-server.enable = true;

  xdg.portal.config.niri = {
    "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
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
