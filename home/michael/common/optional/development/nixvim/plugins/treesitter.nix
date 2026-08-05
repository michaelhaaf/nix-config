#
{ ... }:
{
  plugins = {
    treesitter = {
      enable = true;
      # folding.enable = true; # 26.05
      nixvimInjections = true;
      indent = {
        enable = true;
        disable = [ "python" ];
      };
      settings = {
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
