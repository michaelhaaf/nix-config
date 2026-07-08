{
  pkgs,
  ...
}:
{
  services.displayManager = {
    sessionPackages = [ pkgs.plasma-bigscreen ];
    defaultSession = "plasma-bigscreen-wayland";
    sddm = {
      settings.Autologin = {
        User = "homie";
        Session = "plasma-bigscreen-wayland";
        Relogin = true;
      };
    };
  };

  # 144 DIP = 1.5x standard - readable from couch distance at 1080p
  environment.etc."xdg/kcmfonts".text = ''
    [General]
    forceFontDPI=144
  '';

  environment.systemPackages = with pkgs; [
    plasma-bigscreen
    kdePackages.plasmatube
    kdePackages.plasma-settings
  ];
}
