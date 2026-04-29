# git is core no matter what but additional settings may could be added made in optional/foo   eg: development.nix
{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    delta
  ];
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

    lfs.enable = true;
    settings = {
      alias = {
        graph = "log --decorate --oneline --graph";
        # Adapted from: https://github.com/datsfilipe/dotfiles/blob/main/modules/programs/git/user.nix
        br = "branch";
        co = "checkout";
        sw = "switch";
        st = "status -sb";
        sf = "show --name-only";
        rc = "reset --soft HEAD~1";
        r = "reset HEAD --";
        u = "checkout --";
        c = "commit -m";
        ca = "commit -am";
        ps = "push";
        psu = "push -u";
        pl = "pull";
        mt = "mergetool";
        dt = "difftool";
        psm = "!git push origin $(git rev-parse --abbrev-ref HEAD)";
        plm = "!git pull origin $(git rev-parse --abbrev-ref HEAD)";
        lg = "log --graph --name-status --pretty=format:\"%C(red)%h %C(reset)(%cd) %C(green)%an %Creset%s %C(yellow)%d%Creset\" --date=relative";
        chbase = "!f() { git rebase --onto=$1 $2 $(git symbolic-ref --short HEAD); }; f";
        eu = "!f() { git ls-files --unmerged | cut -f2 | sort -u ; }; vim `f`";
        au = "!f() { git ls-files --unmerged | cut -f2 | sort -u ; }; git add `f`";
        incc = "!(git fetch --quiet && git log --pretty=format:'%C(yellow)%h %C(white)- %C(red)%an %C(white)- %C(cyan)%d%Creset %s %C(white)- %ar%Creset' ..@{u})";
        outc = "!(git fetch --quiet && git log --pretty=format:'%C(yellow)%h %C(white)- %C(red)%an %C(white)- %C(cyan)%d%Creset %s %C(white)- %ar%Creset' @{u}..)";
        rev = "!f() { git ls-remote $1 HEAD | awk '{print $1}'; }; f";
        sp = "submodule update --init --recursive";
        sfor = "submodule foreach";
      };
      user = {
        email = lib.mkDefault inputs.nix-secrets.git.email;
        name = inputs.nix-secrets.git.name;
      };
      core = {
        pager = "delta";
        editor = "nvim";
      };
      merge = {
        conflictStyle = "zdiff3";
        tool = "nvimdiff";
      };
      mergetool = {
        keepBackup = false;
        conflictStyle = "zdiff3"; # TODO: which one? merge or mergetool?
        nvimdiff.layout = "LOCAL,BASE,REMOTE / MERGED";
      };
      diff = {
        tool = "nvimdiff";
        algorithm = "histogram";
      };
      commit = {
        gpgSign = lib.mkDefault true;
        commit.verbose = true;
      };
      init.defaultBranch = "main";
      log.date = "iso";
      column.ui = "auto";
      branch.sort = "committerdate";
      push.autoSetupRemote = true;
      rerere.enabled = true;
      delta = {
        enable = true;
        features = [
          "navigate"
          "side-by-side"
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
