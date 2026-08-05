{ inputs, lib, ... }:
{
  imports = [ inputs.noctalia.homeModules.default ];

  # TODO: real wall paper management
  home.file."media/pictures/wallpapers" = {
    recursive = true;
    source = lib.custom.relativeToRoot "assets/wallpapers";
  };

  services = {
    cliphist = {
      enable = true;
    };
    clipse = {
      enable = false;
    };
  };

  programs.noctalia = {
    enable = true;
    settings = {
      theme = {
        mode = "dark";
        source = lib.mkDefault "community";
        community_palette = "Catppuccin Macchiato Pink";
        wallpaper_scheme = "vibrant";
        builtin = "Catppuccin";
      };
      backdrop = {
        enabled = true;
        blur_intensity = 0.5;
        tint_intensity = 0.3;
      };
      default_session = {
        # TODO: variables
        command = "/run/current-system/sw/bin/noctalia-greeter-session --session Niri --user michael";
        user = "michael";
      };
      dock = {
        enabled = true;
        background_opacity = lib.mkDefault 0.66;
        active_monitor_only = true;
        auto_hide = true;
        reserve_space = false;
        launcher_position = "start";
      };
      control_center = {
        sidebar = "full";
      };
      idle = {
        behavior_order = [ "screen-off" ];
        behavior = {
          screen-off = {
            action = "screen_off";
            enabled = true;
            timeout = 600;
          };
        };
      };
      keybinds = {
        down = [
          "Ctrl+n"
          "Down"
        ];
        up = [
          "Ctrl+p"
          "Up"
        ];
        right = [
          "Ctrl+t"
          "Right"
        ];
        left = [
          "Ctrl+d"
          "Left"
        ];
      };
      location = {
        auto_locate = true;
      };
      nightlight = {
        enabled = true;
        force = true;
      };
      shell = {
        # TODO: variable
        avatar_path = "/home/michael/.face";
        screen_time_enabled = true;
        panel = {
          launcher_session_search = true;
          open_near_click_control_center = true;
          session_placement = "centered";
          wallpaper_placement = "centered";
          transparency_mode = "glass";
        };
      };
      bar = {
        order = [ "main" ];
        main = {
          enabled = true;
          position = "top";
          reserve_space = true; # reserve compositor exclusive zone / push windows away
          layer = "top"; # top | overlay; overlay appears above fullscreen apps
          capsule = false;
          radius = 0;
          margin_edge = 0;
          margin_ends = 0;
          background_opacity = 0.66;
          start = [
            "launcher"
            "workspaces"
            "active_window"
          ];
          center = [ "clock" ];
          end = [
            "weather"
            "media"
            "notifications"
            "network"
            "volume"
            "brightness"
            "bluetooth"
            "battery"
            "session"
          ];

        };
      };
      widget = {
        launcher = {
          glyph = "menu-2";
          custom_image_colorize = false;
        };
        clock = {
          anchor = true;
          format = "%A %d %B %H:%M:%S";
          tooltip_format = "%c";
          vertical_format = "%Hh%M";
        };
        media = {
          hide_when_no_media = true;
          title_scroll = "always";
        };
        network = {
          show_label = false;
        };
        workspaces = {
          display = "none";
        };
        active_window = {
          capsule = true;
        };
        weather = {
          show_condition = false;
        };
        volume = {
          show_condition = false;
        };
        brightness = {
          show_condition = false;
        };
        battery = {
          show_condition = false;
        };
      };

      wallpaper = {
        enabled = true;
        directory = "/home/michael/media/pictures/wallpapers";
        # TODO: get from theme
        fill_color = "#232136";
        fill_mode = "crop";
        transition_on_startup = false;
        edge_smoothness = 0.3;
        automation.enabled = true;
      };
    };
  };

}
