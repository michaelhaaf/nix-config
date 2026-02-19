{ ... }:
{
  plugins = {
    undotree = {
      enable = true;

    };
  };
  keymaps = [
    {
      mode = [ "n" ];
      key = "<Leader>u";
      action = ":UndotreeToggle<cr>";
      options = {
        desc = "Toggle undotree"; # see undotree plugin
        noremap = true;
      };
    }

  ];
}
