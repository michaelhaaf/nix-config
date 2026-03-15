#############################################################
#
#  wsl - Windows Development Environment (NixOS WSL2 container)
#
###############################################################

{
  inputs,
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
    inputs.stylix.nixosModules.stylix

    (map lib.custom.relativeToRoot [
      #
      # ========== Required Configs ==========
      #
      "hosts/common/core"

      #
      # ========== Optional Configs ==========
      #
      "hosts/common/optional/services/openssh.nix" # allow remote SSH access
      "hosts/common/optional/wayland.nix" # WSL uses wayland
      # TODO: https://gist.github.com/tdcosta100/e28636c216515ca88d1f2e7a2e188912 ?
      # "hosts/common/optional/sway.nix" # minimal sway setup on top of WSL Weston
      "hosts/common/optional/xdg.nix" # XDG spec modifications
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
  ];

  # Alternative that doesn't effect other files -- depreciated and doesn't work
  # inputs.vscode-remote-workaround.enable = true;

  # NEW METHOD FOR VSCODE FROM: https://github.com/nix-community/nixos-vscode-server

  #   # I think this is unneccecary if I'm going with standalone home-manager rather than flake os module home-manager
  #   home-manager = {
  #     extraSpecialArgs = { inherit inputs outputs; };
  #     users = {
  #       # Import your home-manager configuration
  #       gig = import ../../../home/gig/ganosLal/wsl.nix;
  #     };
  #   };

  # TODO: move this stuff to separate file but define theme itself per host
  # host-wide styling
  stylix = {
    enable = true;
    image = (lib.custom.relativeToRoot "assets/wallpapers/zen-01.png");
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";
    opacity = {
      applications = 1.0;
      terminal = 1.0;
      desktop = 1.0;
      popups = 0.8;
    };
    polarity = "dark";
  };
}
