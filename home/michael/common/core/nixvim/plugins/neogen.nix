{
  plugins.neogen = {
    enable = true;
    settings.snippet_engine = "luasnip";
    settings.languages = {
      javascript.template.annotation_convention = "jsdoc";
      javascriptreact.template.annotation_convention = "jsdoc";
      typescript.template.annotation_convention = "tsdoc";
      typescriptreact.template.annotation_convention = "tsdoc";
      lua.template.annotation_convention = "ldoc";
      ruby.template.annotation_convention = "yard";
      # python.template.annotation_convention = "reST";
      python.template.annotation_convention = "numpydoc";
      # python.template.annotation_convention = "google_docstrings";
    };
  };
  keymaps = [
    {
      key = "<leader>cgf";
      mode = [ "n" ];
      action = "<cmd>lua require('neogen').generate({ type = 'func' })<CR>";
      options = {
        desc = "(c)ode (g)enerate (f)unction annotation";
      };
    }
    {
      key = "<leader>cgc";
      mode = [ "n" ];
      action = "<cmd>lua require('neogen').generate({ type = 'class' })<CR>";
      options = {
        desc = "(c)ode (g)enerate (c)lass annotation";
      };
    }
  ];
}
