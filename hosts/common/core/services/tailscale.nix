{ ... }:
{

  # TODO: Tailscale configuration with secrets
  # To enable Tailscale on WSL:
  # 1. Generate auth key for WSL in Tailscale admin console with these settings:
  #    - Description: "wsl-nixos-auto-auth"
  #    - Reusable: Yes, Ephemeral: No, Pre-approved: Yes
  #    - Expiry: 1 year (or never)
  # 2. Add "wsl-auth: tskey-auth-..." to tailscale-creds in secrets.yaml
  # 3. Import the tailscale module in imports above
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    # TODO: incorporate your own domain like this
    # extraUpFlags = ["--login-server https://tailscale.m7.rs"];
  };
  networking.firewall.allowedUDPPorts = [ 41641 ]; # Facilitate firewall punching
}
