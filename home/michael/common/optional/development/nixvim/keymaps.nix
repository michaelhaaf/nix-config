{
  programs.nixvim = {
    globals.mapleader = " ";
    keymaps = [
      #
      # ======== User Interface =======
      #

      {
        mode = [ "n" ];
        key = "<leader>ui";
        action = "<cmd>vim.show_pos<CR>";
        options = {
          desc = "Inspect Pos";
        };
      }

      {
        mode = [ "n" ];
        key = "<leader>uT";
        action = "<cmd>lua Snacks.toggle.treesitter()<CR>";
        options = {
          desc = "Toggle (t)reesitter";
        };
      }

      {
        mode = [ "n" ];
        key = "<leader>us";
        action = "<cmd>lua Snacks.toggle.option('spell', { name = 'Spelling' })<CR>";
        options = {
          desc = "Toggle (s)pelling";
        };
      }

      {
        mode = [ "n" ];
        key = "<leader>ud";
        action = "<cmd>lua Snacks.toggle.diagnostics()<CR>";
        options = {
          desc = "Toggle (d)iagnostics";
        };
      }

      #
      # ======== Movement ========
      #
      {
        mode = [ "n" ];
        key = "j";
        action = "gj";
        options = {
          desc = "Move down through wrapped lines";
          noremap = true;
        };
      }
      {
        mode = [ "n" ];
        key = "k";
        action = "gk";
        options = {
          desc = "Move up through wrapped lines";
          noremap = true;
        };
      }

      #
      # ======== better indenting ========
      #
      {
        mode = [ "x" ];
        key = "<";
        action = "<gv";
      }
      {
        mode = [ "x" ];
        key = ">";
        action = ">gv";
      }

    ];
  };
}
