{ inputs, ... }:
{
  imports = [ inputs.noctalia.homeModules.default ];

  stylix.targets.noctalia-shell.enable = true;
  #  noctalia-shell ipc call state all | jq .settings | bat
  programs.noctalia-shell = {
    enable = true;
    plugins = {
      sources = [
        {
          enabled = true;
          name = "Official Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        polkit-agent = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        tailscale = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        catwalk = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
      version = 2;
    };
    pluginSettings = {
      catwalk = {
        minimumThreshold = 25;
        hideBackground = true;
      };
    };
    settings = {
      # configure noctalia here
      bar = {
        barType = "floating";
        density = "default";
        position = "top";
        showCapsule = false;
        widgets = {
          left = [
            {
              id = "Launcher";
              colorizeSystemIcon = "none";
              enableColorization = true;
              useDistroLogo = true;
            }
            {
              id = "Workspace";
              hideUnoccupied = false;
              labelMode = "none";
            }
            {
              id = "Taskbar";
              colorizeIcons = true;
              hideMode = "hidden";
              maskTaskbarWidth = 40;
              onlyActiveWorkspaces = true;
              showPinnedApps = true;
              showTitle = false;
              smartWidth = true;
              titleWidth = 120;
            }
            {
              id = "ActiveWindow";
              colorizeIcons = true;
              hideMode = "hidden";
              maxWidth = 145;
              scrollingMode = "hover";
              showIcon = true;
              useFixedWidth = true;
            }
          ];
          center = [
            {
              id = "plugin:catwalk";
              defaultSettings = {
                hideBackground = false;
                minimumThreshold = 10;
              };
            }
            {
              id = "Clock";
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
              useMonospacedFont = true;
              usePrimaryColor = true;
            }
            {
              id = "AudioVisualizer";
              hideWhenIdle = true;
              colorName = "primary";
              width = 200;
            }
          ];
          right = [
            {
              id = "plugin:tailscale";
              defaultSettings = {
                compactMode = false;
              };
            }
            { id = "Network"; }
            { id = "Volume"; }
            {
              alwaysShowPercentage = false;
              id = "Battery";
              warningThreshold = 30;
            }
          ];
        };
      };
      # colorSchemes.predefinedScheme = "Monochrome";
      general = {
        avatarImage = "/home/michael/.face";
        radiusRatio = 0.2;
        lockScreenCountdownDuration = 3000;
        keybinds = {
          keyUp = [
            "Up"
            "Ctrl+P"
          ];
          keyDown = [
            "Down"
            "Ctrl+N"
          ];
        };
      };
      location = {
        monthBeforeDay = true;
        name = "Montreal, Canada";
      };
      desktopWidgets = {
        enabled = true;
        gridSnap = true;
        overviewEnabled = true;
        monitorWidgets = [ ];
      };
      wallpaper = {
        directory = "/home/michael/media/pictures/wallpapers";
      };
      sessionMenu = {
        countdownDuration = 3000;

      };
    };
  };

}
