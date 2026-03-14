{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.openrbg-with-all-plugins
  ];
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrbg-with-all-plugins;
    motherboard = "amd";
  };

}
