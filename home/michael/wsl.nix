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
  ];

  # services.yubikey-touch-detector.enable = true;
  # services.yubikey-touch-detector.notificationSound = true;

}
