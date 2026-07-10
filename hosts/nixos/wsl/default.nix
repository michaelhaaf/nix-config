#############################################################
#
#  wsl - Windows Development Environment (NixOS WSL2 container)
#
###############################################################

{
  pkgs,
  lib,
  ...
}:
{
  imports = lib.flatten [
    ./configuration.nix

    #
    # ========== Misc Inputs ==========
    #

    (map lib.custom.relativeToRoot [
      #
      # ========== Required Configs ==========
      #
      "hosts/common/core"

      #
      # ========== Optional Configs ==========
      #
      "hosts/common/optional/desktops/wayland.nix" # WSL uses wayland

      "hosts/common/optional/services/openssh.nix" # allow remote SSH access
      # TODO: https://gist.github.com/tdcosta100/e28636c216515ca88d1f2e7a2e188912 ?
      # "hosts/common/optional/sway.nix" # minimal sway setup on top of WSL Weston
      "hosts/common/optional/xdg.nix" # XDG spec modifications
      "hosts/common/optional/stylix.nix"
      "hosts/common/optional/nix-ld.nix"
    ])
  ];

  #
  # ========== Host Specification ==========
  #

  hostSpec = {
    hostName = "wsl";
    primaryUser = "michael";
    users = [
      "michael"
    ];
  };

  networking.hostName = "wsl";

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld;
  };

  environment.systemPackages = with pkgs; [
    wayland
    libxkbcommon
    tzdata
  ];

}
