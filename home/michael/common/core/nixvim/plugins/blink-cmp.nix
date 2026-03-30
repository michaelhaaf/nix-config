# Adapted from: https://github.com/XhuyZ/nixvim/blob/main/config/blink-cmp.nix
{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [
    blink-ripgrep-nvim
  ];

  plugins = {
    # blink-pairs.enable = true; # not available in 25.11, need unstable
    blink-cmp-dictionary.enable = true;
    blink-cmp-git.enable = true;
    blink-cmp-spell.enable = true;
    blink-emoji.enable = true;
    blink-ripgrep.enable = true;
    blink-cmp = {
      enable = true;
      setupLspCapabilities = true;

      settings = {
        keymap = {
          preset = "default";
        };
        signature = {
          enabled = true;
          window = {
            border = "rounded";
          };
        };

        sources = {
          default = [
            "buffer"
            "lsp"
            "path"
            "snippets"
            # Community
            "dictionary"
            "emoji"
            "git"
            "spell"
            "ripgrep"
          ];
          providers = {
            ripgrep = {
              name = "Ripgrep";
              module = "blink-ripgrep";
              score_offset = 1;
            };
            dictionary = {
              name = "Dict";
              module = "blink-cmp-dictionary";
              min_keyword_length = 3;
            };
            emoji = {
              name = "Emoji";
              module = "blink-emoji";
              score_offset = 1;
            };
            lsp.score_offset = 4;
            spell = {
              name = "Spell";
              module = "blink-cmp-spell";
              score_offset = 1;
            };
            git = {
              name = "Git";
              module = "blink-cmp-git";
              enabled = true;
              score_offset = 100;
              should_show_items.__raw = ''
                function()
                  return vim.o.filetype == 'gitcommit' or vim.o.filetype == 'markdown'
                end
              '';
              opts = {
                git_centers = {
                  github = {
                    issue = {
                      on_error.__raw = "function(_,_) return true end";
                    };
                  };
                };
              };
            };
          };
        };

        appearance = {
          nerd_font_variant = "mono";
          kind_icons = {
            Text = "󰉿";
            Method = "";
            Function = "󰊕";
            Constructor = "󰒓";

            Field = "󰜢";
            Variable = "󰆦";
            Property = "󰖷";

            Class = "󱡠";
            Interface = "󱡠";
            Struct = "󱡠";
            Module = "󰅩";

            Unit = "󰪚";
            Value = "󰦨";
            Enum = "󰦨";
            EnumMember = "󰦨";

            Keyword = "󰻾";
            Constant = "󰏿";

            Snippet = "󱄽";
            Color = "󰏘";
            File = "󰈔";
            Reference = "󰬲";
            Folder = "󰉋";
            Event = "󱐋";
            Operator = "󰪚";
            TypeParameter = "󰬛";
            Error = "󰏭";
            Warning = "󰏯";
            Information = "󰏮";
            Hint = "󰏭";

            Emoji = "🤶";
          };
        };
        completion = {
          menu = {
            border = "rounded";
            draw = {
              gap = 1;
              treesitter = [ "lsp" ];
              columns = [
                {
                  __unkeyed-1 = "label";
                }
                {
                  __unkeyed-1 = "kind_icon";
                  __unkeyed-2 = "kind";
                  gap = 1;
                }
                { __unkeyed-1 = "source_name"; }
              ];
            };
          };
          trigger = {
            show_in_snippet = false;
          };
          documentation = {
            auto_show = true;
            window = {
              border = "rounded";
            };
          };
          accept = {
            auto_brackets = {
              enabled = false;
            };
          };
        };
      };
    };
  };
}
