{ ... }:
{
  plugins = {
    todo-comments = {
      enable = true;
      settings = {
        # patterns from: https://github.com/folke/todo-comments.nvim/issues/10
        search.pattern = "\b(KEYWORDS)(\([^\)]*\))?:";
        highlight.pattern = ".*<((KEYWORDS)%(\(.{-1,}\))?):";
      };
    };
  };
}
