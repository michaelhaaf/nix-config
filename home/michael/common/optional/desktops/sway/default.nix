{ ... }:
{
  imports = [
    ./scripts.nix
  ];

  programs.bash = {
    sessionVariables = {
      XDG_SESSION_DESKTOP = "sway";
      XDG_SESSION_TYPE = "wayland";
      XDG_RUNTIME_DIR = "/run/user/1000";
      WAYLAND_DISPLAY = "wayland-0";
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod3"; # numpad by default, for Windows only atm
      startup = [
        # { command = "firefox"; }
      ];
    };
  };
}
