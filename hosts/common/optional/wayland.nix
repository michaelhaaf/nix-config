{ pkgs, ... }:
{
  # general packages related to wayland
  environment.systemPackages = with pkgs; [
    grim # screen capture component, required by flameshot
    slurp # screenshot functionality
    wl-clipboard # copy/paste
    mako # notifications
    waypaper # wayland packages(nitrogen analog for wayland)
    swww # backend wallpaper daemon required by waypaper
    tofi # dmenu equivalent
    wayland-utils # diagnotstic tools
  ];
}
