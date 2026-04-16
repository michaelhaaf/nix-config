# Adapted from https://github.com/bjeanes/dotfiles/blob/main/packages/nvim/plugins/conform.nix
{ lib, pkgs, ... }:
{
  keymaps = [
    {
      key = "<leader>cf";
      action = "<cmd>lua require('conform').format({ timeout_ms = 3000 })<CR>";
      mode = [
        "n"
        "x"
      ];
      options = {
        desc = "Format Injected Langs";
      };
    }
  ];
  plugins.conform-nvim = {
    enable = true;
    settings = {
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
        python = [
          "ruff_fix"
          "ruff_format"
          "ruff_organize_imports"
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
        ruff = {
          command = lib.getExe pkgs.ruff;
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
