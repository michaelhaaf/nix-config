{ config, pkgs, ... }:
let
  user = config.hostSpec.user;
  tailscale_auth_key =
    if config.hostSpec.isAdmin then
      config.sops."tailscale/admin-oauth-secret".path
    else
      config.sops."tailscale/server-oauth-secret".path;
  routing_features = if config.hostSpec.isServer then "both" else "client";
in
{
  sops.secrets."tailscale/admin-oauth-secret" = { };
  sops.secrets."tailscale/server-oauth-secret" = { };
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  services.resolve.enable = true;
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = routing_features;
    extraUpFlages = [
      "--accept-routes=false"
      "--operator=${user}"
    ];
  };

  # create a oneshot job to authenticate to Tailscale
  # adapted from: https://iadw.in/automatically-connect-to-tailscale-in-nixos-with-oauth-secrets/
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = [
      "network-pre.target"
      "tailscale.service"
    ];
    wants = [
      "network-pre.target"
      "tailscale.service"
    ];
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # authenticate with tailscale
      ${tailscale}/bin/tailscale up --auth-key=${tailscale_auth_key}
      ${tailscale}/bin/tailscale set --operator=${user}
    '';
  };
}
