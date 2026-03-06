{ lib, pkgs, ... }:
{
  imports = lib.flatten [
    (lib.custom.scanPaths ./.)
  ];
  programs.niri = {
    package = pkgs.unstable.niri;
    settings = {
      spawn-at-startup = [
        {
          command = [
            "noctalia-shell"
          ];
        }
      ];
    };
  };
  home = {
    packages = lib.attrValues {
      inherit (pkgs.unstable)
        xwayland-satellite # xwayland support
        ;
    };
    file = {
      ".config/niri/config.kdl".source = ./config.kdl;
      ".config/niri/inputs.kdl".source = ./inputs.kdl;
      ".config/niri/outputs.kdl".source = ./outputs.kdl;
      ".config/niri/binds.kdl".source = ./binds.kdl;
      ".config/niri/rules.kdl".source = ./rules.kdl;
    };
  };
}
