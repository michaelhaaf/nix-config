# Adapted from: https://github.com/XhuyZ/nixvim/blob/main/config/snacks.nix
{
  lib,
  config,
  ...
}:
{
  plugins.snacks = {
    enable = true;
    autoLoad = true;
    settings = {
      bigfile.enabled = true;
      dim.enabled = true;
      gh.enabled = true;
      git.enabled = true;
      zen.enabled = true;
      input.enabled = true;
      gitbrowse.enabled = true;
      scratch.enabled = true;
      quickfile.enabled = true;
      words.enabled = true;
      scope.enabled = true;
      toggle.enabled = true;
      picker = {
        enable = true;
        sources = {
          noice = lib.mkIf config.plugins.noice.enable {
            confirm = [
              "yank"
              "close"
            ];
          };
        };
      };
      dashboard = {
        sections = [
          {
            header = ''
              ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
              ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
              ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
              ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
              ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
              ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
            '';
          }
          {
            icon = " ";
            title = "Keymaps";
            section = "keys";
            gap = 1;
            padding = 1;
          }
          {
            icon = " ";
            title = "Find Files";
            __unkeyed-1.__raw = "require('snacks').dashboard.sections.recent_files({cwd = true})";
            gap = 1;
            padding = 1;
          }
          {
            icon = " ";
            title = "Projects";
            section = "projects";
            gap = 1;
            padding = 1;
          }
          {
            pane = 1;
            icon = " ";
            desc = "Browse Repo";
            padding = 1;
            key = "b";
            action.__raw = ''
              function()
                Snacks.gitbrowse()
              end'';
          }
          (lib.mkIf config.plugins.lazy.enable { section = "startup"; })
        ];
      };
    };
  };
  keymaps = [
    {
      key = "<leader><space>";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.smart()<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "Smart Find Files";
      };
    }
    {
      key = "<leader>e";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.explorer()<CR>";
      options = {
        desc = "File Explorer";
      };
    }
    {
      key = "<leader>?";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.grep()<CR>";
      options = {
        silent = true;
        noremap = true;
      };
    }
    {
      key = "<leader>n";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.notifications()<CR>";
      options = {
        silent = true;
        noremap = true;
      };
    }
    {
      key = "<leader>fb";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.buffers()<CR>";
      options = {
        silent = true;
        noremap = true;
      };
    }
    {
      key = "<leader>ff";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.files()<CR>";
      options = {
        silent = true;
        noremap = true;
      };
    }
    {
      key = "<leader>gl";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.git_log()<CR>";
      options = {
        silent = true;
        noremap = true;
      };
    }
    {
      key = "<leader>gb";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.git_branches()<CR>";
      options = {
        silent = true;
        noremap = true;
      };
    }
    {
      key = "<leader>gG";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.gitbrowse()<CR>";
      options = {
        silent = true;
        noremap = true;
      };
    }
    {
      key = "<leader>gs";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.git_status()<CR>";
      options = {
        silent = true;
        noremap = true;
      };
    }
    {
      key = "<leader>uC";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.colorschemes()<CR>";
      options = {
        desc = "Color schemes";
      };
    }
    {
      key = "<leader>:";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.command_history()<CR>";
      options = {
        desc = "Command history";
      };
    }
    {
      key = "<leader>sC";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.commands()<CR>";
      options = {
        desc = "Commands";
      };
    }
    {
      # Goto Definition
      key = "gd";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.lsp_definitions()<CR>";
      options = {
        desc = "(LSP) go to definition";
      };
    }
    {
      # Goto Declaration
      key = "gD";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.lsp_declarations()<CR>";
      options = {
        desc = "(LSP) go to declaration";
      };
    }
    {
      # References
      key = "gr";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.lsp_references()<CR>";
      options = {
        desc = "(LSP) go to references";
      };
    }
    {
      # Goto Implementation
      key = "gI";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.lsp_implementations()<CR>";
      options = {
        desc = "(LSP) go to implementation";
      };
    }
    {
      # Goto Type Definition (gy)
      key = "gy";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.lsp_type_definitions()<CR>";
      options = {
        desc = "(LSP) go to type definition";
      };
    }

    # LSP Symbols
    {
      key = "<leader>ss";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.lsp_symbols()<CR>";
      options = {
        desc = "(LSP) symbols";
      };
    }

    # LSP Workspace Symbols
    {
      key = "<leader>sS";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.lsp_workspace_symbols()<CR>";
      options = {
        desc = "(LSP) workplace symbols";
      };
    }

    # GitHub PRs (all)
    {
      key = "<leader>gP";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.gh_pr({ state = 'all' })<CR>";
      options = {
        desc = "(GH) PRs (all)";
      };
    }

    # GitHub PRs (open)
    {
      key = "<leader>gp";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.gh_pr()<CR>";
      options = {
        desc = "(GH) PRs (open)";
      };
    }

    # GitHub Issues (all)
    {
      key = "<leader>gI";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.gh_issue({ state = 'all' })<CR>";
      options = {
        desc = "(GH) issues (all)";
      };
    }

    # GitHub Issues (open)
    {
      key = "<leader>gi";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.gh_issue()<CR>";
      options = {
        desc = "(GH) issues (open)";
      };
    }

    # Help pages
    {
      key = "<leader>sh";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.help()<CR>";
      options = {
        desc = "(s)earch (h)elp";
      };
    }

    # Keymaps
    {
      key = "<leader>sk";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.keymaps()<CR>";
      options = {
        desc = "(s)earch (k)eymaps";
      };
    }

    # Marks
    {
      key = "<leader>sm";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.marks()<CR>";
      options = {
        desc = "(s)earch (m)arks";
      };
    }

    # man pages
    {
      key = "<leader>sM";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.man()<CR>";
      options = {
        desc = "(s)earch (M)anpages";
      };
    }

    # Location list
    {
      key = "<leader>sl";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.loclist()<CR>";
      options = {
        desc = "(s)earch (l)ocation list";
      };
    }

    # Quickfix list
    {
      key = "<leader>sq";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.qflist()<CR>";
      options = {
        desc = "(s)earch (q)uickfix list";
      };
    }

    # Undo history
    {
      key = "<leader>su";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.undo()<CR>";
      options = {
        desc = "(s)earch (u)ndo history";
      };
    }

    # Git blame
    {
      key = "<leader>gB";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.git.blame_line()<CR>";
      options = {
        desc = "(s)earch (u)ndo history";
      };
    }

  ];
}
