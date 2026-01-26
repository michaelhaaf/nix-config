{ pkgs, ... }:
{

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "catpuccin-mocha-mauve";
  };
  services.desktopManager.plasma6.enable = true;

  services.kdeconnect = {
    enable = true;
    indicator = true;
    package = pkgs.kdePackages.kdeconnect-kde;
  };

  environment.systemPackages = with pkgs; [
    (catpuccin-sddm.override {
      flavor = "mocha";
      accent = "mauve";
    })
    kdePackages.sddm-kcm
    kdePackages.ksystemlog
  ];

}
