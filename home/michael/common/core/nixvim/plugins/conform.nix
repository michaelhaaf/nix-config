# Adapted from https://github.com/bjeanes/dotfiles/blob/main/packages/nvim/plugins/conform.nix
{ lib, pkgs, ... }:
{
  plugins.conform-nvim = {
    enable = true;
    settings = {
      # NOTE:
      # Conform will run multiple formatters sequentially
      # [ "1" "2" "3"]
      # Add stop_after_first to run only the first available formatter
      # { "__unkeyed-1" = "foo"; "__unkeyed-2" = "bar"; stop_after_first = true; }
      # Use the "*" filetype to run formatters on all filetypes.
      # Use the "_" filetype to run formatters on filetypes that don't
      # have other formatters configured.
      formatters_by_ft = {
        bash = [
          "shellcheck"
          "shellharden"
          "shfmt"
        ];
        css = [ "stylelint" ];
        javascript = {
          __unkeyed-1 = "biome";
          __unkeyed-2 = "prettierd";
          timeout_ms = 2000;
          stop_after_first = true;
        };
        json = [ "jq" ];
        lua = [ "stylua" ];
        markdown = [
          "injected"
          "mdformat"
        ];
        nix = [ "nixfmt" ];
        rust = [ "rustfmt" ];
        sh = [
          "shellcheck"
          "shellharden"
          "shfmt"
        ];
        toml = [ "taplo" ];
        typescript = {
          __unkeyed-1 = "biome";
          __unkeyed-2 = "prettierd";
          timeout_ms = 2000;
          stop_after_first = true;
        };
        yaml = [ "yamlfmt" ];
        "_" = [
          "trim_whitespace"
          "trim_newlines"
        ];
      };

      formatters = {
        jq = {
          command = lib.getExe pkgs.jq;
        };
        nixfmt = {
          command = lib.getExe pkgs.nixfmt-rfc-style;
        };
        mdformat =
          let
            pyPkgs = pkgs.python312Packages;
          in
          {
            command = lib.getExe (
              pkgs.writeShellApplication {
                name = "mdformat";

                runtimeInputs = [
                  pyPkgs.mdformat
                  pyPkgs.mdformat-myst
                ];

                text = ''
                  mdformat "$@"
                '';
              }
            );
          };
        prettierd = {
          command = lib.getExe pkgs.prettierd;
        };
        rustfmt = {
          command = lib.getExe pkgs.rustfmt;
        };
        shellcheck = {
          command = lib.getExe pkgs.shellcheck;
        };
        shfmt = {
          command = lib.getExe pkgs.shfmt;
        };
        shellharden = {
          command = lib.getExe pkgs.shellharden;
        };
        stylelint = {
          command = lib.getExe pkgs.stylelint;
        };
        stylua = {
          command = lib.getExe pkgs.stylua;
        };
        taplo = {
          command = lib.getExe pkgs.taplo;
        };
        yamlfmt = {
          command = lib.getExe pkgs.yamlfmt;
        };
      };
    };
  };
}
