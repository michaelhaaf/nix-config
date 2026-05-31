{
  pkgs,
  ...
}:

{
  gtk = {
    enable = true;
    iconTheme = {
      name = "elementary-Xfce-dark";
      package = pkgs.elementary-xfce-icon-theme;
    };
    gtk4.theme = null;
  };
}
