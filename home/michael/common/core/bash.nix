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
    };
  };
}
