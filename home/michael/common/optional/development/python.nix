# Source: https://github.com/aca/nix-config/blob/main/dev/python.nix

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
}
