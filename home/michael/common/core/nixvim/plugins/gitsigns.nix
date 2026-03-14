{ ... }:
{
  plugins = {
    gitsigns = {
      enable = true;
      settings = {
        current_line_blame = true;
        # current_line_blame_formatter = "   <author>, <committer_time:%R> • <summary>";
      };
    };
  };
  keymaps = [
    {
      mode = [ "n" ];
      key = "<Leader>gd";
      action = "<cmd>Gitsigns diffthis<CR>";
      options = {
        desc = "Diff this buffer";
        noremap = true;
      };
    }
    {
      mode = [ "n" ];
      key = "<Leader>ghs";
      action = "<cmd>Gitsigns stage_hunk<CR>";
      options = {
        desc = "Stage hunk";
        noremap = true;
      };
    }
    {
      mode = [ "n" ];
      key = "<Leader>ghu";
      action = "<cmd>Gitsigns reset_hunk<CR>";
      options = {
        desc = "Reset hunk";
        noremap = true;
      };
    }
    {
      mode = [ "n" ];
      key = "<Leader>ghp";
      action = "<cmd>Gitsigns preview_hunk_inline<CR>";
      options = {
        desc = "Preview hunk (inline)";
        noremap = true;
      };
    }
  ];
}
