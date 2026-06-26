{
  pkgs,
  ...
}:
let
  fuzzy-nix-search = pkgs.writeShellApplication {
    name = "ns";
    runtimeInputs = with pkgs; [
      fzf
      nix-search-tv
    ];
    text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
  };
in
{
  home.packages = [
    pkgs.nix-search-tv
    pkgs.optnix # trying this one out
    fuzzy-nix-search
  ];
}
