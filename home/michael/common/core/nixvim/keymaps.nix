{
  programs.nixvim = {
    globals.mapleader = " ";
    #
    # ========== Modes Legend ==========
    #
    #    "n" Normal mode
    #    "i" Insert mode
    #    "v" Visual and Select mode
    #    "s" Select mode
    #    "t" Terminal mode
    #    ""  Normal, visual, select and operator-pending mode
    #    "x" Visual mode only, without select
    #    "o" Operator-pending mode
    #    "!" Insert and command-line mode
    #    "l" Insert, command-line and lang-arg mode
    #    "c" Command-line mode
    keymaps = [
      #
      # ========== Nixvim Config Shortcuts ==========
      #

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

      #
      # ======== Zen ========
      #
      {
        mode = [ "n" ];
        key = "<Leader>zz";
        action = ":ZenMode<CR>";
        options = {
          desc = "toggle ZenMode";
          noremap = true;
        };
      }
    ];
  };
}
