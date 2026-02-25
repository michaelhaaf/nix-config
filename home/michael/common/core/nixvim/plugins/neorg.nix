{
  plugins.neorg = {
    enable = true;
    settings = {
      load = {
        "core.concealer" = {
          config = {
            icon_preset = "varied";
          };
        };
        "core.summary" = {
          config = {
            strategy = "default";
          };
        };
        "core.dirman" = {
          config = {
            workspaces = {
              home = "~/notes/home";
              work = "~/notes/work";
            };
          };
        };
      };
    };
  };
}
