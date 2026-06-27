{
  plugins.remote-nvim = {
    enable = true;

    # Offline mode: copy data locally instead of NVIM release.
    # https://nix-community.github.io/nixvim/plugins/remote-nvim/index.html
    settings = {
      offline_mode = {
        enabled = true;
        no_github = true;
      };
      remote = {
        copy_dirs = {
          data = {
            base = {
              __raw = "vim.fn.stdpath (\"data\")";
            };
            compression = {
              additional_opts = [
                "--exclude-vcs"
              ];
              enabled = true;
            };
            dirs = [
              "lazy"
            ];
          };
        };
      };
    };
  };
}
