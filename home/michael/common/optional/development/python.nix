# Source: https://github.com/aca/nix-config/blob/main/dev/python.nix

{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    (pkgs.writeShellScriptBin "python" ''
      exec uv run python "$@"
    '')

    (pkgs.writeShellScriptBin "python3" ''
      exec uv run python "$@"
    '')

    (pkgs.writeShellScriptBin "py" ''
      exec uv run python "$@"
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
