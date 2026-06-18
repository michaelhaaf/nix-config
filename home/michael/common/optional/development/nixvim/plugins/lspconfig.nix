{
  ...
}:
{
  plugins = {
    lsp-format = {
      enable = true;
    };
    lsp = {
      enable = true;
      inlayHints = true;
      keymaps = {
        silent = true;
        lspBuf = {
          K = {
            action = "hover";
            desc = "Hover";
          };
          "<leader>cw" = {
            action = "workspace_symbol";
            desc = "Workspace Symbol";
          };
          "<leader>cr" = {
            action = "rename";
            desc = "Rename";
          };
          "<leader>ca" = {
            action = "code_action";
            desc = "Code Action";
          };
          "<leader>ch" = {
            action = "signature_help";
            desc = "Signature Help";
          };
        };
        diagnostic = {
          "<leader>cd" = {
            action = "open_float";
            desc = "Line Diagnostics";
          };
          "]d" = {
            action = "goto_next";
            desc = "Next Diagnostic";
          };
          "[d" = {
            action = "goto_prev";
            desc = "Previous Diagnostic";
          };
        };
      };
    };
  };
}
