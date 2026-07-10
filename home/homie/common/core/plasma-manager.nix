{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [ inputs.plasma-manager.homeModules.plasma-manager ];
  home.packages = with pkgs; [
    papirus-icon-theme
  ];

  config = lib.mkIf config.stylix.enable {
    stylix.targets.qt.platform = "qtct";
  };
  programs.plasma = {
    enable = true;

    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      cursor.size = 48;
      iconTheme = "Papirus-Dark";
      wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Patak/contents/images/1080x1920.png";
    };

    input.keyboard = {
      numlockOnStartup = "on";
    };

    shortcuts = {
      # kwin = {
      #   "ExposeClassCurrentDesktop" = "Meta+Ctrl+Down";
      #   "Overview" = "Meta+Ctrl+Up";
      # };
    };

    # System Settings > Keyboard > Shortcuts > Plasma Manager
    hotkeys.commands = {
      # launch-brave = {
      #   name = "Launch Brave";
      #   key = "Meta+Shift+B";
      #   command = "brave";
      # };
    };

    # System Settings > Colors & Themes > Window Decorations
    kwin.titlebarButtons.left = [
      "close"
      "minimize"
      "maximize"
    ];

    kwin = {
      # System Settings > Window Management > Desktop Effects > ...
      effects = {
        blur = {
          enable = true;
          noiseStrength = 0;
          strength = 6;
        };
        slideBack.enable = true;
        translucency.enable = true;
        wobblyWindows.enable = true;
      };
    };

    # System Settings > Screen Locking > Configure Appearance
    kscreenlocker = {
      appearance = {
        showMediaControls = true;
        wallpaperPictureOfTheDay.provider = "bing";
      };
    };

    # System Settings > Session > Desktop Session
    session = {
      general.askForConfirmationOnLogout = false;
    };

    krunner = {
      position = "center";
    };

    spectacle = {
      shortcuts = {
        captureActiveWindow = "Meta+@";
        captureCurrentMonitor = "Meta+#";
        captureRectangularRegion = "Meta+$";
        launchWithoutCapturing = "Meta+%";
      };
    };

    configFile = {
      # System Settings > Search > File Search
      baloofilerc."Basic Settings"."Indexing-Enabled" = false;

      # GUI setting unknown
      # Use detailed view for file picker
      kdeglobals."KFileDialog Settings"."View Style" = "Detail";

      # System Settings > Colors & Themes > Splash Screen
      ksplashrc.KSplash = {
        Engine = "none";
        Theme = "None";
      };

      kwinrc = {
        # System Settings > Window Management > Desktop Effects > Geometry Change
        # Add Geometry Change: System Settings > Window Management > Desktop Effects >
        #   Get New...
        Effect-kwin4_effect_geometry_change."Duration" = 500;
      };

      # Spectacle > Configure Spectacle
      "spectaclerc"."General"."launchAction" = "DoNotTakeScreenshot";
    };
  };

}
