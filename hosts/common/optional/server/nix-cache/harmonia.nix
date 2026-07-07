# Harmonia binary cache server
{ config, ... }:

{
  sops.secrets = {
    "harmonia/private_key" = { };
  };

  services.harmonia = {

    cache = {
      enable = true;
      signKeyPaths = [ config.sops.secrets."harmonia/private_key".path ];
      settings = {
        bind = "[::]:5000";
        workers = 4;
        max_connection_rate = 256;
        priority = 50; # Lower than cache.nixos.org (40)
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    443
    80
  ];

  security.acme.defaults.email = "michael.haaf@gmail.com";
  security.acme.acceptTerms = true;

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    virtualHosts."cache.minerva.michaelhaaf.net" = {
      enableACME = true;
      forceSSL = true;

      locations."/".extraConfig = ''
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_redirect http:// https://;
        proxy_http_version 1.1;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
      '';
    };
  };

}
