{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
    settings = {
      scrollback-limit = 10000;
      shell-integration-features = "ssh-terminfo, ssh-env";
    };
    enableBashIntegration = true;
  };
}
