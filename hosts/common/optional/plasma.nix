{ pkgs, ... }:
{

  # TODO: import config to enable this stuff
  # security.pam.services.${config.hostSpec.primaryDesktopUsername} = {
  #   kwallet = {
  #     enable = true;
  #     package = pkgs.kdePackages.kwallet-pam;
  #   };
  # };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "catpuccin-mocha-mauve";
  };
  services.desktopManager.plasma6.enable = true;

  programs.kdeconnect.enable = true;

  environment.systemPackages = with pkgs; [
    (catppuccin-sddm.override {
      flavor = "mocha";
      accent = "mauve";
    })
    kdePackages.sddm-kcm
    kdePackages.ksystemlog
    kdePackages.discover
    kdePackages.kscreen
  ];

}
