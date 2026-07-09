{
  config,
  ...
}:
{
  sops.secrets = {
    "sabnzbd/api_key" = { };
    "sabnzbd/nzb_key" = { };
    "sabnzbd/password" = { };
    "usenet/eweka/username" = { };
    "usenet/eweka/password" = { };
    "usenet/eweka/server" = { };
  };

  nixflix.usenetClients.sabnzbd = {
    enable = true;
    subdomain = "nzb";
    settings = {
      misc = {
        username = "sabnzbd";
        password._secret = config.sops.secrets."sabnzbd/password".path;
        api_key._secret = config.sops.secrets."sabnzbd/api_key".path;
        nzb_key._secret = config.sops.secrets."sabnzbd/nzb_key".path;
      };
      servers = [
        {
          name = "Eweka";
          host = "news.eweka.nl";
          port = 563;
          username._secret = config.sops.secrets."usenet/eweka/username".path;
          password._secret = config.sops.secrets."usenet/eweka/password".path;
          connections = 20;
          ssl = true;
          priority = 0;
          retention = 3000;
        }
      ];
    };
  };

}
