{
  plugins.smart-splits = {
    enable = true;
    lazyLoad.enable = false;
    autoLoad = true;
  };
  keymaps = [

    # Switch focus
    {
      mode = [ "n" ];
      key = "<C-k>";
      action.__raw = "function() require('smart-splits').move_cursor_up() end";
      options = {
        desc = "Go to Upper Window";
        remap = true;
      };
    }
    {
      mode = [ "n" ];
      key = "<C-j>";
      action.__raw = "function() require('smart-splits').move_cursor_down() end";
      options = {
        desc = "Go to Lower Window";
        remap = true;
      };
    }
    {
      mode = [ "n" ];
      key = "<C-h>";
      action.__raw = "function() require('smart-splits').move_cursor_left() end";
      options = {
        desc = "Go to Left Window";
        remap = true;
      };
    }
    {
      mode = [ "n" ];
      key = "<C-l>";
      action.__raw = "function() require('smart-splits').move_cursor_right() end";
      options = {
        desc = "Go to Right Window";
        remap = true;
      };
    }

    # Resize
    {
      mode = [ "n" ];
      key = "<A-k>";
      action.__raw = "function() require('smart-splits').resize_up() end";
      options = {
        desc = "Increase Window Height";
      };
    }
    {
      mode = [ "n" ];
      key = "<A-j>";
      action.__raw = "function() require('smart-splits').resize_down() end";
      options = {
        desc = "Decrease Window Height";
      };
    }
    {
      mode = [ "n" ];
      key = "<A-h>";
      action.__raw = "function() require('smart-splits').resize_left() end";
      options = {
        desc = "Decrease Window Width";
      };
    }
    {
      mode = [ "n" ];
      key = "<A-l>";
      action.__raw = "function() require('smart-splits').resize_right() end";
      options = {
        desc = "Increase Window Height";
      };
    }

    # Swap buffers
    {
      mode = [ "n" ];
      key = "<leader><C-k>";
      action.__raw = "function() require('smart-splits').swap_buf_up() end";
      options = {
        desc = "Swap buffer up";
      };
    }
    {
      mode = [ "n" ];
      key = "<leader><C-j>";
      action.__raw = "function() require('smart-splits').swap_buf_down() end";
      options = {
        desc = "Swap buffer down";
      };
    }
    {
      mode = [ "n" ];
      key = "<leader><C-h>";
      action.__raw = "function() require('smart-splits').swap_buf_left() end";
      options = {
        desc = "Swap buffer left";
      };
    }
    {
      mode = [ "n" ];
      key = "<leader><C-l>";
      action.__raw = "function() require('smart-splits').swap_buf_right() end";
      options = {
        desc = "Swap buffer right";
      };
    }

  ];
}
