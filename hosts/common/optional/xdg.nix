{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xdg-user-dirs
    xdg-user-dirs-gtk
    xdg-desktop-portal-gtk
  ];
  environment.etc."xdg/user-dirs.defaults".text = ''
    DESKTOP=desktop
    DOWNLOAD=downloads
    TEMPLATES=templates
    PUBLICSHARE=public
    DOCUMENTS=documents
    MUSIC=media/music
    PICTURES=media/pictures
    VIDEOS=media/video
  '';
}
