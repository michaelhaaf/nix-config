{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.nixflix.nixosModules.default
  ]
  ++ lib.custom.scanPaths ./.;

  sops.secrets = {
    "wireguard-confs/protonvpn-homelab-confinement" = { };
  };

  nixflix = {
    enable = true;

    mediaDir = "/data/media";
    stateDir = "/data/.state";

    mediaUsers = [ config.hostSpec.primaryUsername ];

    theme = {
      enable = true;
      name = "catpuccin-mocha";
    };

    vpn = {
      enable = true;
      wgConfFile = config.sops.secrets."wireguard-confs/protonvpn-homelab-confinement".path;
      # TODO: figure out subnets better
      accessibleFrom = [ "192.168.2.0/24" ];
    };

    nginx = {
      enable = true;

      # TODO: disable when I add my own DNS
      addHostsEntries = true;

      # TODO: jellyfin needs a real certificate or something
      # forceSSL = true;

      # TODO: You have to configure security.acme.certs.$${nixflix.nginx.domain} in order to use this.
      # enableACME = true;
    };
    postgres.enable = true;

    recyclarr = {
      enable = true;
    };

  };
}
