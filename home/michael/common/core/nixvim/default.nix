# Adapted from https://github.com/EmergentMind/nix-config/blob/5f0bad660b1ff71ef2f0454f675c055d1e0a79f5/home/common/core/nixvim/plugins/default.nix
# Some fantastic inspiration for this config
# https://seniormars.com/posts/neovim-workflow/

{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./plugins
    ./keymaps.nix
  ];

  programs.bash = {
    shellAliases = {
      vim = "nvim";
      vi = "nvim";
      v = "nvim";
    };
    sessionVariables = {
      MANPAGER = "nvim +Man!";
    };
  };

  programs.nixvim = {
    nixpkgs.pkgs = import <nixpkgs> { };

    # TODO: actually address this
    version.enableNixpkgsReleaseCheck = false;

    enable = true;
    enableMan = true; # install man pages for nixvim options
    defaultEditor = true;
    vimdiffAlias = true;

    colorschemes.rose-pine = {
      enable = true;
      settings = {
        dark_variant = "moon";
      };
    };

    lsp = {
      servers = {
        "*" = {
          config = {
            capabilities = {
              textDocument = {
                semanticTokens = {
                  multilineTokenSupport = true;
                };
              };
            };
            root_markers = [
              ".git"
            ];
          };
        };
        basedpyright = {
          # enable = true;
          # packageFallback = true;
          enable = false; # Trying different servers for now.
        };
        bashls = {
          enable = true;
        };
        biome = {
          enable = true;
        };
        clangd = {
          enable = true;
          config = {
            cmd = [
              "clangd"
              "--background-index"
            ];
            filetypes = [
              "c"
              "cpp"
            ];
            root_markers = [
              "compile_commands.json"
              "compile_flags.txt"
            ];
          };
        };
        jsonls = {
          enable = true;
        };
        lua_ls = {
          enable = true;
        };
        marksman = {
          enable = true;
        };
        nixd = {
          enable = true;
        };
        ruff = {
          enable = true;
          packageFallback = true;
          config = {
            cmd = [
              "ruff"
              "server"
            ];
            filetypes = [ "python" ];
            root_markers = [
              "pyproject.toml"
              "ruff.toml"
              ".ruff.toml"
            ];
            settings = {
              configurationPrefence = "filesystemFirst";
            };
          };
        };
        texlab = {
          enable = true;
        };
        ts_ls = {
          enable = true;
        };
        yamlls = {
          enable = true;
        };
        zuban = {
          enable = true;
          packageFallback = true;
          config = {
            cmd = [
              "zuban"
              "server"
            ];
            filetypes = [ "python" ];
            root_markers = [
              "pyproject.toml"
            ];
            settings = {
              configurationPrefence = "filesystemFirst";
            };
          };
        };
      };
    };

    opts = {
      #
      # ========= General Appearance =========
      #
      hidden = true; # Makes vim act like all other editors, buffers can exist in the background without being in a window. http://items.sjbach.com/319/configuring-vim-right
      relativenumber = true; # show relative linenumbers
      laststatus = 0; # Display status line always
      history = 1000; # Store lots of :cmdline history
      showcmd = true; # Show incomplete cmds down the bottom
      showmode = true; # Show current mode down the bottom
      autoread = true; # Reload files changed outside vim
      showmatch = true; # highlight matching braces
      ruler = true; # show current line and column
      visualbell = true; # No sounds

      # Clipboard
      clipboard = {
        providers.wl-copy.enable = true;
      };

      textwidth = 90;

      # ================ Indentation ======================
      autoindent = true;
      cindent = true; # automatically indent braces
      smarttab = true;
      shiftwidth = 2;
      softtabstop = 0;
      tabstop = 4;
      expandtab = true;

      # ================ Folds ============================
      foldmethod = "indent"; # fold based on indent
      foldnestmax = 3; # deepest fold is 3 levels
      foldenable = false; # don't fold by default

      # ================ Completion =======================
      wildmode = "list:longest,list:full"; # for tab completion in : command mode
      wildmenu = true; # enable ctrl-n and ctrl-p to scroll thru matches
      # stuff to ignore when tab completing
      wildignore = "*.o,*.obj,*~,vim/backups,sass-cache,DS_Store,vendor/rails/**,vendor/cache/**,*.gem,log/**,tmp/**,*.png,*.jpg,*.gif";

      # ================ Scrolling ========================
      scrolloff = 4; # Start scrolling when we're 4 lines away from margins
      sidescrolloff = 15;
      sidescroll = 1;

      # ================ Search and Replace ========================
      hlsearch = false; # highlight search results
      inccommand = "split"; # preview incremental substitutions in a split

      # ================ Movement ========================
      backspace = "indent,eol,start"; # allow backspace in insert mode

      # ================ Undotree ========================
      swapfile = false; # Undotree
      backup = false;
      undofile = true;
    };

    extraPackages = with pkgs; [
      # base
      fzf
      ripgrep
      fd
    ];

    # Load Plugins that aren't provided as modules by nixvim
    # TODO: need to confirm these aren't in nixvim
    extraPlugins = lib.attrValues {
      inherit (pkgs.vimPlugins)
        vim-illuminate # Highlight similar words as are under the cursor
        vim-numbertoggle # Use relative number on focused buffer only
        range-highlight-nvim # Highlight range as specified in commandline e.g. :10,15
        vimade # Dim unfocused buffers

        # Keep vim-devicons as last entry
        vim-devicons
        ;
    };
    extraConfigVim = ''
      " ================ Persistent Undo ==================
      " Keep undo history across sessions, by storing in file.
      if has('persistent_undo')
          silent !mkdir ~/.vim/backups > /dev/null 2>&1
          set undodir=~/.vim/backups
          set undofile
      endif
    '';

  };
}
