{ lib, ... }:
{
  imports = [
    #
    # ========== Required Configs ==========
    #
    common/core

    #
    # ========== Host-specific Optional Configs ==========
    #
    common/optional/desktops/niri

    common/optional/sops.nix
    common/optional/desktops
    common/optional/shell-extras
    common/optional/development
    common/optional/comms
    common/optional/media
    common/optional/tools
  ]
  ++ map lib.custom.relativeToRoot [
    "home/common/optional/browsers/firefox.nix"
    "home/common/optional/browsers/librewolf.nix"
    "home/common/optional/browsers/chromium.nix"
    "home/common/optional/browsers/brave.nix"
  ];

  services.kanshi = {
    enable = true;
    settings = [
      {
        profile.name = "default";
        profile.outputs = [
          {
            criteria = "DP-3";
            scale = 1.0;
            position = "0,0";
            mode = "1920x1080";
            status = "enable";
          }
          {
            criteria = "HDMI-A-1";
            scale = 1.25;
            position = "1920,0";
            mode = "3840x2160";
            status = "enable";
          }
        ];

      }
    ];
  };

}
