{ ... }:
{
  programs.btop = {
    enable = true;
    settings = {
      # TODO: set via stylix
      # color_theme = lib.mkForce "catppuccin_mocha";
      round_corners = true;
      theme_background = true;
      vim_keys = true;
    };
  };
}
