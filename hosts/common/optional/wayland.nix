{ pkgs, ... }:
{
  # general packages related to wayland
  environment.systemPackages = with pkgs; [
    wl-clipboard # copy/paste
    wayland-utils # diagnotstic tools
    wlr-randr
  ];
}
