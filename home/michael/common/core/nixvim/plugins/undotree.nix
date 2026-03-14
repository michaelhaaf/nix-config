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
      key = "<Leader>uu";
      action = ":UndotreeToggle<cr>";
      options = {
        desc = "Toggle undotree"; # see undotree plugin
        noremap = true;
      };
    }

  ];
}
