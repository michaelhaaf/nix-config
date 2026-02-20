{ ... }:
{
  imports = [
    #
    # ========== Required Configs ==========
    #
    common/core

    #
    # ========== Host-specific Optional Configs ==========
    #
    # common/optional/development
    # common/optional/helper-scripts
    # common/optional/tools

    # common/optional/atuin.nix
    # common/optional/xdg.nix # file associations
    common/optional/sops.nix
    # TODO: https://gist.github.com/tdcosta100/e28636c216515ca88d1f2e7a2e188912 ?
    # common/optional/desktops/sway
  ];

  # services.yubikey-touch-detector.enable = true;
  # services.yubikey-touch-detector.notificationSound = true;

}
