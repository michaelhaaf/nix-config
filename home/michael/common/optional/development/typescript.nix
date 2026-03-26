# Source: https://github.com/aca/nix-config/blob/main/dev/python.nix

{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    (pkgs.buildFHSEnv {
      name = "bun";
      targetPkgs =
        pkgs: with pkgs; [
          bun
        ];

      runScript = "bun";
    })
  ];
  programs.bash = {
    shellAliases = {
      bunx = "bun x";
    };
  };
}
