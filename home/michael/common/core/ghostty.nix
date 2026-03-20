{ pkgs, ... }:
{
  stylix.targets.ghostty.enable = true;
  programs.ghostty = {
    enable = true;
    package = pkgs.unstable.ghostty;
    settings = {
      scrollback-limit = 10000;
      shell-integration-features = "ssh-terminfo, ssh-env";
    };
    enableBashIntegration = true;
  };
}
