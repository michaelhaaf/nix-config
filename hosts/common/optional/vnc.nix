{ pkgs, ... }:
{
  # general packages related to wayland
  environment.systemPackages = with pkgs; [
    tigervnc
  ];
}
