{
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true; # better than native direnv nix functionality - https://github.com/nix-community/nix-direnv
    # nix-direnv.package = pkgs.unstable.nix-direnv;
    config = {
      global = {
        log_filter = "^loading"; # https://github.com/direnv/direnv/issues/203#issuecomment-3061299852
      };
    };
  };
}
