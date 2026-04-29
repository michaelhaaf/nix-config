{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
let
  # TODO: put this somewhere more generic i.e. in modules
  niripath = "home/michael/common/optional/desktops/niri";
  createSymlink =
    localPath:
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/${localPath}";
in
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
      ".config/niri/config.kdl".source = createSymlink "${niripath}/config.kdl";
      ".config/niri/inputs.kdl".source = createSymlink "${niripath}/inputs.kdl";
      ".config/niri/binds.kdl".source = createSymlink "${niripath}/binds.kdl";
      ".config/niri/rules.kdl".source = createSymlink "${niripath}/rules.kdl";
    };

  };
}
