{ pkgs, ... }:
{
  hardware.xone.enable = true; # xbox controller

  environment.systemPackages = with pkgs; [
    # bottles
    steam-tui
    steamcmd
  ];

  environment.sessionVariables = {
    STEAM_FORCE_DESKTOPUI_SCALING = "2";
  };

  # TODO: mount share games/mods directories if present

  # nixpkgs.overlays = [ inputs.millennium.overlays.default ];
  programs = {
    steam = {
      enable = true;
      protontricks = {
        enable = true;
        package = pkgs.protontricks;
      };
      # package = pkgs.millennium-steam;
      extraCompatPackages = [ pkgs.unstable.proton-ge-bin ];
      gamescopeSession = {
        enable = true;
      };
    };
    #gamescope launch args set dynamically in home/<user>/common/optional/gaming
    gamescope = {
      enable = true;
      # TODO: look into re-enabling when https://github.com/ValveSoftware/gamescope/pull/2313 is released.
      # See also: https://github.com/NixOS/nixpkgs/issues/351516
      # capSysNice = true;
      capSysNice = false;
    };
    # to run steam games in game mode, add the following to the game's properties from within steam
    # gamemoderun %command%
    gamemode = {
      enable = true;
      settings = {
        #see gamemode man page for settings info
        general = {
          softrealtime = "on";
          inhibit_screensaver = 1;
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 1; # The DRM device number on the system (usually 0), ie. the number in /sys/class/drm/card0/
          amd_performance_level = "high";
        };
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };
  };
}
