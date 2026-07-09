{ pkgs, ... }:
{
  home.packages = [ pkgs.mutagen ];
  home.file.".mutagen.yml".text = ''
    sync:
      defaults:
        ignore:
          vcs: true
  '';
}
