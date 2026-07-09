{
  config,
  ...
}:
{
  sops.secrets = {
    "seerr/api_key" = { };
  };

  nixflix.seerr = {
    enable = true;
    subdomain = "request";
    vpn.enable = false;
    apiKey._secret = config.sops.secrets."seerr/api_key".path;
  };

}
