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
        key = "<C-j>";
        action = "<C-d>";
        options = {
          desc = "Add bind for 1/2 page down";
          noremap = true;
        };
      }
      {
        mode = [ "n" ];
        key = "<C-k>";
        action = "<C-u>";
        options = {
          desc = "Add bind for 1/2 page up";
          noremap = true;
        };
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
