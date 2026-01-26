# git is core no matter what but additional settings may could be added made in optional/foo   eg: development.nix
{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;

    ignores = [
      ".csvignore"
      # nix
      "*.drv"
      "result"
      # python
      "*.py?"
      "__pycache__/"
      ".venv/"
      # direnv
      ".direnv"
    ];

    aliases = {
      graph = "log --decorate --oneline --graph";
    };
    userName = inputs.nix-secrets.git.name;
    userEmail = lib.mkDefault inputs.nix-secrets.git.email;

    lfs.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      commit.gpgSign = lib.mkDefault true;
      core.pager = "delta";
      merge.conflictStyle = "zdiff3";
      commit.verbose = true;
      diff.algorithm = "histogram";
      log.date = "iso";
      column.ui = "auto";
      branch.sort = "committerdate";
      push.autoSetupRemote = true;
      rerere.enabled = true;
      delta = {
        enable = true;
        features = [
          "side-by-side"
          "line-numbers"
          "hyperlinks"
          "line-numbers"
          "commit-decoration"
        ];
      };
      # pre-emptively ignore mac crap
      core.excludeFiles = builtins.toFile "global-gitignore" ''
        .DS_Store
        .DS_Store?
        ._*
        .Spotlight-V100
        .Trashes
        ehthumbs.db
        Thumbs.db
        node_modules
      '';
      core.attributesfile = builtins.toFile "global-gitattributes" ''
        Cargo.lock -diff
        flake.lock -diff
        *.drawio -diff
        *.svg -diff
        *.json diff=json
        *.bin diff=hex difftool=hex
        *.dat diff=hex difftool=hex
        *aarch64.bin diff=objdump-aarch64 difftool=objdump-aarch64
        *arm.bin diff=objdump-arm difftool=objdump-arm
        *x64.bin diff=objdump-x86_64 difftool=objdump-x64
        *x86.bin diff=objdump-x86 difftool=objdump-x86
      '';
      # Makes single line json diffs easier to read
      diff.json.textconv = "jq --sort-keys .";
    };

  };

}
