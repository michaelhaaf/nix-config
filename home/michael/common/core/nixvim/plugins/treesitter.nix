#
{ ... }:
{
  plugins = {
    treesitter = {
      enable = true;
      folding = true;
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
