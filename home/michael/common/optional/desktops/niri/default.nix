{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = lib.flatten [
    inputs.niri-flake.homeModules.niri
    (lib.custom.scanPaths ./.)
  ];
  programs.niri.settings = {
    environment."NIXOS_OZONE_WL" = "1";
  };
  xdg.configFile.niri-config.target = lib.mkForce "niri/nix-generated-config.kdl";
  home = {
    packages = lib.attrValues {
      inherit (pkgs.unstable)
        xwayland-satellite # xwayland support
        fuzzel
        ;
    };
    file = {
      ".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink ./config.kdl;
      ".config/niri/inputs.kdl".source = config.lib.file.mkOutOfStoreSymlink ./inputs.kdl;
      ".config/niri/binds.kdl".source = config.lib.file.mkOutOfStoreSymlink ./binds.kdl;
      ".config/niri/rules.kdl".source = config.lib.file.mkOutOfStoreSymlink ./rules.kdl;
    };

  };
}
