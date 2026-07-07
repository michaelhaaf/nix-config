{
  config,
  inputs,
  lib,
  ...
}:
let
  domainName = "${config.hostSpec.hostName}.${config.hostSpec.domain}";
in
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
      domain = domainName;
      addHostsEntries = false;
      forceSSL = true;
      enableACME = true;
    };
    postgres.enable = true;

    recyclarr = {
      enable = true;
    };

  };
}
