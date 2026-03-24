{ config, ... }:
{
  imports = [
    #
    # ========== Required Configs ==========
    #
    common/core

    #
    # ========== Host-specific Optional Configs ==========
    #
    # common/optional/helper-scripts
    # common/optional/tools

    # common/optional/atuin.nix
    # common/optional/xdg.nix # file associations

    common/optional/development
    common/optional/sops.nix
    common/optional/shell-extras

    # TODO: https://gist.github.com/tdcosta100/e28636c216515ca88d1f2e7a2e188912 ?
    # common/optional/desktops/sway
  ];

  home.file = {
    ".local/bin/win32yank.exe".source =
      config.lib.file.mkOutOfStoreSymlink "/mnt/c/Program Files/Neovim/bin/win32yank.exe";
  };

  # services.yubikey-touch-detector.enable = true;
  # services.yubikey-touch-detector.notificationSound = true;

  programs.nixvim = {
    extraConfigLua = ''
      vim.g.clipboard = {
          name = "win32yank-wsl",
          copy = {
              ["+"] = "win32yank.exe -i --crlf",
              ["*"] = "win32yank.exe -i --crlf",
          },
          paste = {
              ["+"] = "win32yank.exe -o --lf",
              ["*"] = "win32yank.exe -o --lf",
          },
          cache_enabled = true,
      }
    '';
  };

}
