# Reminder that CUPS cpanel defaults to localhost:631

{ lib, pkgs, ... }:
{
  services.printing = {
    enable = true;
    drivers = [ pkgs.samsung-unified-linux-driver ];
    #logging = "debug";
  };

  # Mitigate cups and avahi security issue as described here: https://discourse.nixos.org/t/cups-cups-filters-and-libppd-security-issues/52780/2
  # Note: this will eventually be achievable with the option `services.printing.browsed.enabled = false` but the PR hasn't been merged to unstable as of 09.10.24
  systemd.services.cups-browsed = {
    enable = false;
    unitConfig.Mask = true;
  };

  # SANE - scanner access now easy
  hardware.sane = {
    enable = true;
    extraBackends = [
      pkgs.samsung-unified-linux-driver
      pkgs.hplipWithPlugin
      pkgs.sane-airscan
    ];
  };
  services.udev.packages = [ pkgs.sane-airscan ];
  services.ipp-usb.enable = true;

  environment.systemPackages = lib.attrValues {
    inherit (pkgs)
      simple-scan # GUI scanning application
      sane-frontends
      ; # Command-line scanning tools
  };

  # If your scanner is networked, you might need to open a port
  # networking.firewall.allowedTCPPorts = [ 9100 ];
}
