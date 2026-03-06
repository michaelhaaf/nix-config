{ lib, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.adi1090x-plymouth-themes ];
  boot = {
    kernelParams = [
      "quiet" # shut up kernel output prior to prompts
    ];
    plymouth = {
      enable = true;
      # Colorful Sliced
      # Hexagon 2
      # Rings
      theme = lib.mkForce "colorful_sliced";
      themePackages = [
        (pkgs.adi1090x-plymouth-themes.override { selected_themes = [ "colorful_sliced" ]; })
      ];
    };
    consoleLogLevel = 0;
  };
}
