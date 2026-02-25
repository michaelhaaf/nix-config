{ ... }:
{
  plugins.luasnip = {
    enable = true;
    settings = {
      enable_autosnippets = true;
    };
    fromSnipmate = [
      {
        paths = ../snippets/markdown.snippets;
        include = [ "markdown" ];
      }
    ];
  };
}
