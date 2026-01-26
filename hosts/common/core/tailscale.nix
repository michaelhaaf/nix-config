{ ... }:
{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    # TODO: incorporate your own domain like this
    # extraUpFlags = ["--login-server https://tailscale.m7.rs"];
  };
  networking.firewall.allowedUDPPorts = [ 41641 ]; # Facilitate firewall punching
}
