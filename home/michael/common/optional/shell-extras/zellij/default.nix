{
  pkgs,
  ...
}:
{
  programs.zellij = {
    enable = true;
    package = pkgs.zellij;
  };

  home.file.".config/zellij/config.kdl".source = ./config.kdl;
  home.file.".config/zellij/layouts".source = ./layouts;
  # TODO: temporarily disabling zellij autostart, gonna see if wezterm does the trick
  # home.file.".bashrc.d/zellij.rc".source = ./zellij.rc;

  programs.bash = {
    shellAliases = {
      zl = "zellij";
      zls = "zellij list-sessions";
      zla = "zellij attach";
    };
  };

}
