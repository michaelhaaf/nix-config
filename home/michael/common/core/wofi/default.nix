{
  pkgs,
  ...
}:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      wofi-pass
      ;
  };
  xdg.configFile."wofi-pass/config".source = ./wofi-pass-config;
  programs.wofi = {
    enable = true;
    settings = {
      key_up = "Ctrl-p";
      key_down = "Ctrl-n";
    };
    style = ''
      * {
        font-family: monospace;
      }
    '';
  };
}
