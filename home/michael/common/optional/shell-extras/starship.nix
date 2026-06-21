{ lib, pkgs, ... }:
{
  home.file.".bashrc.d/starship.rc".source = ./starship.rc;

  programs = {
    starship = {
      enable = true;
      enableBashIntegration = true;
      package = pkgs.unstable.starship;
      settings = {
        command_timeout = 100;
        # palette = "catppuccin_pine";
        add_newline = false; # see starship.rc
        line_break.disabled = true;
        format = lib.concatStrings [
          "$all\n"
          "$character"
        ];

        character = {
          success_symbol = "[\\$](green)";
          error_symbol = "[!](red)";
          vimcmd_symbol = "[❮](green)";
        };

        username = {
          show_always = true;
          style_user = "bold purple";
          style_root = "red bold";
          format = "[$user]($style)@";
        };

        hostname = {
          ssh_only = false;
          style = "bold purple";
          trim_at = "";
          format = "[$ssh_symbol$hostname]($style)";
        };

        fill = {
          symbol = " ";
          style = "bold green_pine";
        };

        directory = {
          style = "bold lavender";
          truncate_to_repo = true;
          fish_style_pwd_dir_length = 1;
          format = " [$path]($style)[$read_only]($read_only_style) ";
        };

        time = {
          disabled = false;
          time_format = "%R";
          style = "fg:lavender";
          format = "[$time]($style)";
        };

        # TODO: not this
        palettes.catppuccin_pine = {
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          pink = "#f5c2e7";
          mauve = "#cba6f7";
          red = "#f38ba8";
          maroon = "#eba0ac";
          peach = "#fab387";
          yellow = "#f9e2af";
          teal = "#94e2d5";
          sky = "#89dceb";
          sapphire = "#74c7ec";
          blue = "#89b4fa";
          lavender = "#b4befe";
          text = "#cdd6f4";
          subtext1 = "#bac2de";
          subtext0 = "#a6adc8";
          overlay2 = "#9399b2";
          overlay1 = "#7f849c";
          overlay0 = "#6c7086";
          surface2 = "#585b70";
          surface1 = "#45475a";
          surface0 = "#313244";
          base = "#1e1e2e";
          mantle = "#181825";
          crust = "#11111b";
          rose = "#eb6f92";
          orange = "#ea9a97";
          gold = "#f6c177";
          green = "#9ccfd8";
          turquoise = "#3e8fb0";
          purple = "#c4a7e7";
          base_alt = "#232136";
          surface0_alt = "#2a273f";
          surface1_alt = "#393552";
        };
      };
    };
  };
}
