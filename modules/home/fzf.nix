# Adapted from https://github.com/teto/home/blob/main/hm/modules/fzf.nix
/*
  Most of it stolen from
  https://github.com/junegunn/fzf/wiki/Examples-(completion)#zsh-pass
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.fzf;

  inherit (pkgs) fzf-git-sh;

in
{
  options = {
    programs.fzf = {
      enableFzfRg = lib.mkEnableOption "enableFzfRg";
      enableFzfRga = lib.mkEnableOption "enableFzfRga";
      enableFzfFd = lib.mkEnableOption "enableFzfFd";
      enableFzfGit = lib.mkEnableOption "enableFzfGit";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enableFzfFd (
      let
        fzfCompgen = ''
          # Use fd (https://github.com/sharkdp/fd) instead of the default find
          # command for listing path candidates.
          # - The first argument to the function ($1) is the base path to start traversal
          # - See the source code (completion.{bash,zsh}) for the details.
          _fzf_compgen_path() {
            fd --hidden --follow --exclude ".git" . "$1"
          }

          # Use fd to generate the list for directory completion
          _fzf_compgen_dir() {
            fd --type d --hidden --follow --exclude ".git" . "$1"
          }
        '';
      in
      {
        programs.bash.initExtra = fzfCompgen;
      }
    ))

    (lib.mkIf cfg.enableFzfRg (
      let
        fzfRgVim = ''
          # ripgrep->fzf->vim [QUERY]
          # adapted from: https://junegunn.github.io/fzf/tips/ripgrep-integration/
          fzf-rg() (
            RELOAD='reload:rg --column --color=always --smart-case {q} || :'
            OPENER='if [[ $FZF_SELECT_COUNT -eq 0 ]]; then
                      $EDITOR {1} +{2}     # No selection. Open the current line in Vim.
                    else
                      $EDITOR +cw -q {+f}  # Build quickfix list for the selected items.
                    fi'
            fzf --disabled --ansi --multi \
                --bind "start:$RELOAD" --bind "change:$RELOAD" \
                --bind "enter:become:$OPENER" \
                --bind "ctrl-o:execute:$OPENER" \
                --bind 'alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
                --delimiter : \
                --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
                --preview-window '~4,+{2}+4/3,<80(up)' \
                --query "$*"
          )
        '';
      in
      {
        programs.bash.initExtra = fzfRgVim;
      }
    ))

    (lib.mkIf cfg.enableFzfRga (
      let
        fzfRga = ''
          # https://github.com/phiresky/ripgrep-all/wiki/fzf-Integration
          fzf-rga() {
            RG_PREFIX="rga --files-with-matches"
            local file
            file="$(
              FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
                fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
                  --phony -q "$1" \
                  --bind "change:reload:$RG_PREFIX {q}" \
                  --preview-window="70%:wrap"
            )" &&
            echo "opening $file" &&
            xdg-open "$file"
          }

        '';
      in
      {
        programs.ripgrep-all.enable = true;
        programs.bash.initExtra = fzfRga;
      }
    ))

    (lib.mkIf cfg.enableFzfGit {
      programs.bash.initExtra = "source ${fzf-git-sh}/share/fzf-git-sh/fzf-git.sh";
    })

  ];
}
