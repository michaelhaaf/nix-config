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

    # Pickers, Explorer, Scratch
    {
      key = "<leader><space>";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.smart()<CR>";
      options = {
        desc = "Smart Find Files";
      };
    }
    {
      key = "<leader>.";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.scratch()<CR>";
      options = {
        desc = "Scratch Buffer Toggle";
      };
    }
    {
      key = "<leader>n";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.notifications()<CR>";
      options = {
        desc = "Notifications";
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
      key = "<leader>e";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.explorer()<CR>";
      options = {
        desc = "File Explorer";
      };
    }
    {
      key = "<leader>s/";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.grep()<CR>";
      options = {
        silent = true;
        noremap = true;
      };
    }

    # find
    {
      key = "<leader>fb";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.buffers()<CR>";
      options = {
        desc = "(f)ind (b)uffer";
      };
    }
    {
      key = "<leader>fp";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.projects()<CR>";
      options = {
        desc = "(f)ind (p)roject";
      };
    }
    {
      key = "<leader>fg";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.git_files()<CR>";
      options = {
        desc = "(f)ind (g)it files";
      };
    }
    {
      key = "<leader>fc";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.files({cwd=~/nix-config})<CR>";
      options = {
        desc = "(f)ind (c)onfig files";
      };
    }
    {
      key = "<leader>ff";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.files()<CR>";
      options = {
        desc = "(f)ind (f)iles";
      };
    }
    {
      key = "<leader>fr";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.recent()<CR>";
      options = {
        desc = "(f)ind (r)ecent";
      };
    }

    # search
    {
      key = "<leader>s\"";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.registers()<CR>";
      options = {
        desc = "Registers";
      };
    }
    {
      key = "<leader>sg";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.grep()<CR>";
      options = {
        desc = "(s)earch (g)rep";
      };
    }
    {
      key = "<leader>sw";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.grep_word()<CR>";
      options = {
        desc = "(s)earch (w)ord (grep)";
      };
    }
    {
      key = "<leader>sR";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.resume()<CR>";
      options = {
        desc = "Resume";
      };
    }
    {
      key = "<leader>sa";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.autocmds()<CR>";
      options = {
        desc = "(s)earch (a)utocmds";
      };
    }
    {
      key = "<leader>sh";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.help()<CR>";
      options = {
        desc = "(s)earch (h)elp";
      };
    }
    {
      key = "<leader>sk";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.keymaps()<CR>";
      options = {
        desc = "(s)earch (k)eymaps";
      };
    }
    {
      key = "<leader>sj";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.jumps()<CR>";
      options = {
        desc = "(s)earch (j)umps";
      };
    }
    {
      key = "<leader>sD";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.diagnostics_buffer()<CR>";
      options = {
        desc = "(s)earch (D)iagnostics buffer";
      };
    }
    {
      key = "<leader>sd";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.diagnostics()<CR>";
      options = {
        desc = "(s)earch (d)iagnostics";
      };
    }
    {
      key = "<leader>sm";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.marks()<CR>";
      options = {
        desc = "(s)earch (m)arks";
      };
    }
    {
      key = "<leader>sM";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.man()<CR>";
      options = {
        desc = "(s)earch (M)anpages";
      };
    }
    {
      key = "<leader>sl";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.loclist()<CR>";
      options = {
        desc = "(s)earch (l)ocation list";
      };
    }
    {
      key = "<leader>sq";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.qflist()<CR>";
      options = {
        desc = "(s)earch (q)uickfix list";
      };
    }
    {
      key = "<leader>su";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.undo()<CR>";
      options = {
        desc = "(s)earch (u)ndo history";
      };
    }
    {
      key = "<leader>sd";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.diagnostics()<CR>";
      options = {
        desc = "Diagnostics";
      };
    }
    {
      key = "<leader>s/";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.search_history()<CR>";
      options = {
        desc = "Search History";
      };
    }
    {
      key = "<leader>sc";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.commands()<CR>";
      options = {
        desc = "Commands";
      };
    }
    {
      key = "<leader>sB";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.grep_buffer()<CR>";
      options = {
        desc = "(s)earch (B)uffers (grep)";
      };
    }
    {
      key = "<leader>sb";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.lines()<CR>";
      options = {
        desc = "(s)earch (b)uffer Lines";
      };
    }
    {
      key = "<leader>sf";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.files()<CR>";
      options = {
        silent = true;
        noremap = true;
      };
    }
    {
      key = "<leader>ss";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.lsp_symbols()<CR>";
      options = {
        desc = "(LSP) symbols";
      };
    }
    {
      key = "<leader>sS";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.lsp_workspace_symbols()<CR>";
      options = {
        desc = "(LSP) workplace symbols";
      };
    }

    # git
    {
      key = "<leader>gl";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.git_log()<CR>";
      options = {
        desc = "(g)it (l)og";
      };
    }
    {
      key = "<leader>gb";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.git.blame_line()<CR>";
      options = {
        desc = "(g)it (b)lame line";
      };
    }
    {
      key = "<leader>gB";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.git_branches()<CR>";
      options = {
        desc = "(g)it (B)ranches";
      };
    }
    {
      key = "<leader>gs";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.git_status()<CR>";
      options = {
        desc = "(g)it (s)tatus";
      };
    }
    {
      key = "<leader>gd";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.git_diff()<CR>";
      options = {
        desc = "(g)it (d)iff (hunks)";
      };
    }

    # LSP
    {
      key = "gd";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.lsp_definitions()<CR>";
      options = {
        desc = "(LSP) go to definition";
      };
    }
    {
      key = "gD";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.lsp_declarations()<CR>";
      options = {
        desc = "(LSP) go to declaration";
      };
    }
    {
      key = "gr";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.lsp_references()<CR>";
      options = {
        desc = "(LSP) go to references";
      };
    }
    {
      key = "gI";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.lsp_implementations()<CR>";
      options = {
        desc = "(LSP) go to implementation";
      };
    }
    {
      key = "gT";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.lsp_type_definitions()<CR>";
      options = {
        desc = "(LSP) go to type definition";
      };
    }

    # GitHub
    {
      key = "<leader>GP";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.gh_pr({ state = 'all' })<CR>";
      options = {
        desc = "(GH) PRs (all)";
      };
    }
    {
      key = "<leader>Gp";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.gh_pr()<CR>";
      options = {
        desc = "(GH) PRs (open)";
      };
    }
    {
      key = "<leader>GI";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.gh_issue({ state = 'all' })<CR>";
      options = {
        desc = "(GH) issues (all)";
      };
    }
    {
      key = "<leader>Gi";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.gh_issue()<CR>";
      options = {
        desc = "(GH) issues (open)";
      };
    }
    {
      key = "<leader>Gb";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.gitbrowse()<CR>";
      options = {
        desc = "(G)itHub (b)rowse";
      };
    }

    # Buffer management
    {
      key = "<leader>bd";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.bufdelete()<CR>";
      options = {
        desc = "(b)uffer (d)elete";
      };
    }
    {
      key = "<leader>bo";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.bufdelete.other()<CR>";
      options = {
        desc = "(b)uffer delete (o)thers";
      };
    }
    {
      key = "H";
      mode = [ "n" ];
      action = "<cmd>bprevious<CR>";
      options = {
        desc = "Previous buffer";
      };
    }
    {
      key = "L";
      mode = [ "n" ];
      action = "<cmd>bnext<CR>";
      options = {
        desc = "Next buffer";
      };
    }
    {
      key = "<leader>bb";
      mode = [ "n" ];
      action = "<cmd>e #<CR>";
      options = {
        desc = "Switch to Other Buffer";
      };
    }

    # UI
    {
      key = "<leader>uz";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.toggle.zen()<CR>";
      options = {
        desc = "toggle (z)en";
      };
    }
    {
      key = "<leader>uZ";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.toggle.zoom()<CR>";
      options = {
        desc = "Toggle (Z)oom";
      };
    }

    # Movement
    {
      key = "]]";
      mode = [
        "n"
        "t"
      ];
      action = "<cmd>lua Snacks.toggle.jump(vim.v.count1)<CR>";
      options = {
        desc = "Next Reference";
      };
    }
    {
      key = "[[";
      mode = [
        "n"
        "t"
      ];
      action = "<cmd>lua Snacks.toggle.jump(-vim.v.count1)<CR>";
      options = {
        desc = "Prev Reference";
      };
    }

  ];
}
