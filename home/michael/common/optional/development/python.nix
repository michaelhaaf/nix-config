# Install system-wide uv, and aliases to point python -> uv
# Places uv in a fhs env, ostensibly for better management of c modules expecting to be in an fhs
# I believe the above requires nix-ld to work properly.

{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "python" ''
      exec uv run --isolated python "$@"
    '')

    (pkgs.writeShellScriptBin "python3" ''
      exec uv run --isolated python "$@"
    '')

    (pkgs.writeShellScriptBin "py" ''
      exec uv run --isolated python "$@"
    '')

    (pkgs.buildFHSEnv {
      name = "uv";
      targetPkgs =
        pkgs: with pkgs; [
          uv
        ];

      runScript = "uv";
    })
  ];
  programs.bash = {
    shellAliases = {
      uvx = "uv tool run";
    };
  };
}
