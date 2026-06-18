{
  plugins.img-clip = {
    enable = true;
    lazyLoad.settings.ft = [
      "markdown"
      "tex"
      "typst"
    ];

    settings = {
      default = {
        dir_path = "assets";
        relative_to_current_file = true;
        drag_and_drop = {
          enabled = true;
          insert_mode = true;
        };
      };
    };
  };
  keymaps = [
    {
      mode = [ "n" ];
      key = "<leader>p";
      action = "<cmd>PasteImage<CR>";
      options = {
        desc = "Paste image using img-clip";
      };
    }
  ];
}
