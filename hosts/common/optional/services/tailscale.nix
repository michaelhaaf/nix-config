{
  inputs,
  config,
  pkgs,
  ...
}:
let
  sopsFolder = toString inputs.nix-secrets + "/sops";
  user = config.hostSpec.primaryUsername;
  tailscale_auth_key_path =
    if config.hostSpec.isAdmin then "tailscale/admin-oauth-secret" else "tailscale/server-oauth-secret";
  routing_features = if config.hostSpec.isServer then "both" else "client";
in
{
  sops.secrets.${tailscale_auth_key_path} = {
    sopsFile = "${sopsFolder}/shared.yaml";
  };
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  services.resolved.enable = true;
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = routing_features;
    extraUpFlags = [
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
      ${tailscale}/bin/tailscale up --auth-key=${
        config.sops.secrets.${tailscale_auth_key_path}.path
      } --operator=${user}
    '';
  };
}
