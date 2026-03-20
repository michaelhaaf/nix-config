# Adapted from https://github.com/de-abreu/nix-config/blob/main/home/features/programs/cli/nixvim/plugins/navigation/flash.nix
{
  plugins.flash = {
    enable = true;
    settings = {
      label.uppercase = false;
      search.exclude = [
        "notify"
        "cmp_menu"
        "noice"
        "flash_prompt"
        {
          __raw =
            # lua
            ''
              function(win)
                -- exclude non-focusable windows
                return not vim.api.nvim_win_get_config(win).focusable
              end
            '';
        }
      ];
    };
  };
}
