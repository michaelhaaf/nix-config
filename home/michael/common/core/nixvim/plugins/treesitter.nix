#
{ ... }:
{
  plugins = {
    treesitter = {
      enable = true;
      # folding.enable = true; # 26.05
      folding = true; # 25.11
      nixvimInjections = true;
      settings = {
        indent = {
          enable = true;
          disable = [ "python" ];
        };
        incremental_selection = {
          enable = true;
        };
        highlight = {
          enable = true;
          additional_vim_regex_highlighting = true;
        };
      };
    };
    treesitter-context = {
      enable = false;
    };
    treesitter-textobjects = {
      enable = true;
      settings = {
        select = {
          enable = true;
          lookahead = true;
        };
      };
    };
  };
}
