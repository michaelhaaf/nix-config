{
  pkgs,
  ...
}:
let

  #
  # ========== Store Settings Hook ==========
  #
  # Designed to be used as a start-up hook to store the initial noctalia settings.
  startBigScreen = pkgs.writeShellApplication {
    name = "startBigScreen";
    text = ''
      #!/usr/bin/env bash

      export QT_QUICK_CONTROLS_STYLE=org.kde.breeze
      export QT_ENABLE_GLYPH_CACHE_WORKAROUND=1
      export QT_QUICK_CONTROLS_MOBILE=true
      export PLASMA_INTEGRATION_USE_PORTAL=1
      export PLASMA_PLATFORM=mediacenter
      export QT_FILE_SELECTORS=mediacenter

      export XDG_CONFIG_DIRS="$HOME/.config/plasma-bigscreen:/etc/xdg:$XDG_CONFIG_DIRS"

      QT_QPA_PLATFORM=offscreen plasma-bigscreen-envmanager --apply-settings

      export PLASMA_DEFAULT_SHELL=org.kde.plasma.bigscreen
      dbus-run-session kwin_wayland "plasmashell -p org.kde.plasma.bigscreen"
    '';
  };

in
{
  home.packages = [
    startBigScreen
  ];
}
