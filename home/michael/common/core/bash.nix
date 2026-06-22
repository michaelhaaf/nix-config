{ pkgs, ... }:
{
  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
      initExtra = ''
        . ${pkgs.pass.extensions.pass-otp}/share/bash-completion/completions/pass-otp
      '';
      shellAliases = {
        ll = "eza -l --icons=auto --group-directories-first";
        ls = "eza";
        l1 = "eza -1";
        la = "eza -a";
      };
      bashrcExtra = builtins.readFile ./bashrcExtra;
      sessionVariables = {
        # TODO: use config object
        XDG_CONFIG_HOME = /home/michael/.config;
        XDG_CACHE_HOME = /home/michael/.cache;
        XDG_DATA_HOME = /home/michael/.local/share;
        XDG_STATE_HOME = /home/michael/.local/state;
        XDG_DATA_DIRS = "$XDG_DATA_DIRS:$XDG_DATA_HOME/flatpak/exports/share";
      };
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableFzfFd = true;
      enableFzfRg = true;
      enableFzfRga = true;
      enableFzfGit = true;
      fileWidgetOptions = [
        "--height 60%"
        "--border sharp"
        "--layout reverse"
        "--prompt '∷ '"
        "--preview 'bat -n --color=always {}'"
      ];
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}
