{
  lib,
  pkgs,
  ...
}:
{
  plugins = {
    lint = {
      enable = true;
      lintersByFt = {
        bash = [ "shellcheck" ];
        nix = [ "statix" ];
        python = [ "pyright" ];
        # lua = [ "selene" ];
        # javascript = [ "eslint_d" ];
        # javascriptreact = [ "eslint_d" ];
        # typescript = [ "eslint_d" ];
        # typescriptreact = [ "eslint_d" ];
        yaml = [ "yamllint" ];
      };
      linters = {
        pylint = {
          cmd = lib.getExe pkgs.pylint;
        };
        shellcheck = {
          cmd = lib.getExe pkgs.shellcheck;
        };
        statix = {
          cmd = lib.getExe pkgs.statix;
        };
        yamllint = {
          cmd = lib.getExe pkgs.yamllint;
        };
      };
    };
  };
}
