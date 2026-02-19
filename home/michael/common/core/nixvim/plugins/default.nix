{
  # lib,
  ...
}:
{
  # imports = (lib.custom.scanPaths ./.);
  imports = [
    ./gitsigns.nix
    ./blink-cmp.nix
  ];

  programs.nixvim = {
    imports = [
      ./snacks.nix
    ];
  };
}
