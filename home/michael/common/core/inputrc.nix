{ ... }:
{
  programs = {
    readline = {
      enable = true;
      extraConfig = builtins.readFile ./inputrcExtra;
    };
  };
}
