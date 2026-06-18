{
  plugins.img-clip = {
    enable = true;
    # TODO: need lazy loading provider (lz-n?)
    # lazyLoad.settings.ft = [
    #   "markdown"
    #   "tex"
    #   "typst"
    # ];

    settings = {
      default = {
        prompt_for_file_name = false;
        drag_and_drop = {
          enabled = true;
          insert_mode = true;
        };
      };
    };
  };
}
