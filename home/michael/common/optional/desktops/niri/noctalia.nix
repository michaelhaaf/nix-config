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
        density = "compact";
        position = "top";
        showCapsule = false;
        widgets = {
          left = [
            {
              id = "ControlCenter";
              useDistroLogo = true;
            }
            { id = "Network"; }
            { id = "Bluetooth"; }
          ];
          center = [
            {
              hideUnoccupied = false;
              id = "Workspace";
              labelMode = "none";
            }
          ];
          right = [
            {
              alwaysShowPercentage = false;
              id = "Battery";
              warningThreshold = 30;
            }
            {
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
              id = "Clock";
              useMonospacedFont = true;
              usePrimaryColor = true;
            }
          ];
        };
      };
      # colorSchemes.predefinedScheme = "Monochrome";
      general = {
        avatarImage = "/home/michael/.face";
        radiusRatio = 0.2;
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
    };
  };

}
