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

      {
        mode = [ "n" ];
        key = "<C-h>";
        action = "<C-w>h";
        options = {
          desc = "Go to Left Window";
          remap = true;
        };
      }
      {
        mode = [ "n" ];
        key = "<C-j>";
        action = "<C-w>j";
        options = {
          desc = "Go to Lower Window";
          remap = true;
        };
      }
      {
        mode = [ "n" ];
        key = "<C-k>";
        action = "<C-w>k";
        options = {
          desc = "Go to Upper Window";
          remap = true;
        };
      }
      {
        mode = [ "n" ];
        key = "<C-l>";
        action = "<C-w>l";
        options = {
          desc = "Go to Right Window";
          remap = true;
        };
      }

      {
        mode = [ "n" ];
        key = "<C-Up>";
        action = "<cmd>resize +2<CR>";
        options = {
          desc = "Increase Window Height";
        };
      }
      {
        mode = [ "n" ];
        key = "<C-Down>";
        action = "<cmd>resize -2<CR>";
        options = {
          desc = "Decrease Window Height";
        };
      }
      {
        mode = [ "n" ];
        key = "<C-Left>";
        action = "<cmd>vertical resize -2<CR>";
        options = {
          desc = "Decrease Window Width";
        };
      }
      {
        mode = [ "n" ];
        key = "<C-Right>";
        action = "<cmd>vertical resize +2<CR>";
        options = {
          desc = "Increase Window Height";
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
