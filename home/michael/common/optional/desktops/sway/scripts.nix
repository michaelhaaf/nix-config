{
  pkgs,
  ...
}:
let
  swayStartup = pkgs.writeShellApplication {
    name = "swayStartup";
    text = builtins.readFile ./swayStartup.bash;
  };
in
{
  home.packages = [
    swayStartup
  ];
}
