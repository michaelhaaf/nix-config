{ ... }:
{
  plugins.mini = {
    enable = true;
    modules = {
      ai = {
        enable = true;
        n_lines = 50;
        search_method = "cover_or_next";
      };
      align = {
        enable = true;
      };
      comment = {
        enable = true;
        comment = "<leader>/";
        comment_line = "<leader>/";
        comment_visual = "<leader>/";
        textobject = "<leader>/";
      };
      diff = {
        enable = true;
        view = {
          style = "sign";
        };
      };
      move = {
        enable = true;
      };
      operators = {
        enable = true;
      };
      splitjoin = {
        enable = true;
      };
      surround = {
        enable = true;
        # mappings = {
        #   add = "gsa";
        #   delete = "gsd";
        #   find = "gsf";
        #   find_left = "gsF";
        #   highlight = "gsh";
        #   replace = "gsr";
        #   update_n_lines = "gsn";
        # };
      };
    };
  };
}
