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
    user = "admin";
    apiKey._secret = config.sops.secrets."seerr/api_key".path;
  };

}
