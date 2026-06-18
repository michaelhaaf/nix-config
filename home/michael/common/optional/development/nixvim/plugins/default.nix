{
  lib,
  ...
}:
{
  programs.nixvim = {
    imports = (lib.custom.scanPaths ./.);
  };
}
