{
  plugins.persistence = {
    enable = true;
  };
  keymaps = [
    {
      key = "<leader>qs";
      mode = [ "n" ];
      action = "<cmd>lua require('persistence').load()<CR>";
      options = {
        desc = "Restore Session";
      };
    }
    {
      key = "<leader>qS";
      mode = [ "n" ];
      action = "<cmd>lua require('persistence').select()<CR>";
      options = {
        desc = "Select Session";
      };
    }
    {
      key = "<leader>ql";
      mode = [ "n" ];
      action = "<cmd>lua require('persistence').load({last = true})<CR>";
      options = {
        desc = "Restore Last Session";
      };
    }
    {
      key = "<leader>qd";
      mode = [ "n" ];
      action = "<cmd>lua require('persistence').stop()<CR>";
      options = {
        desc = "Don't Save Current Session";
      };
    }
  ];
}
