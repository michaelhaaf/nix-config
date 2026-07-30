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
    # "home/common/optional/browsers/brave.nix"
    # "home/common/optional/browsers/chromium.nix"
  ];

  services.kanshi = {
    enable = true;
    settings = [
      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            scale = 1.0;
            status = "enable";
          }
        ];
      }
      {
        profile.name = "work_office";
        profile.outputs = [
          {
            criteria = "Dell Inc. DELL P2723QE 2HCRRS3";
            position = "0,0";
            mode = "3840x2160";
            scale = 1.5;
          }
          {
            criteria = "Dell Inc. DELL P2723QE HGW2MP3";
            position = "-2560,0";
            mode = "3840x2160";
            scale = 1.5;
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
      }
      {
        profile.name = "classroom_mirror";
        profile.outputs = [
          {
            criteria = "eDP-1";
            position = "0,0";
            mode = "1920x1080";
            status = "enable";
          }
          {
            criteria = "HDMI-A-1";
            position = "0,0";
            mode = "1920x1080";
            status = "enable";
          }
        ];
      }
    ];
  };

}
