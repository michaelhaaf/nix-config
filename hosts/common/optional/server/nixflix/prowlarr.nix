{ config, ... }:
{
  sops.secrets = {
    "indexer-api-keys/Nzb.life" = { };
    "indexer-api-keys/NZBgeek" = { };
    "prowlarr/api_key" = { };
    "prowlarr/password" = { };
  };

  nixflix.prowlarr = {
    enable = true;
    subdomain = "indexers";

    config = {
      apiKey._secret = config.sops.secrets."prowlarr/api_key".path;
      hostConfig.password._secret = config.sops.secrets."prowlarr/password".path;
      indexers = [
        # NZB Indexers
        {
          enable = true;
          name = "Nzb.life";
          apiKey._secret = config.sops.secrets."indexer-api-keys/Nzb.life".path;
        }
        {
          enable = true;
          name = "NZBgeek";
          apiKey._secret = config.sops.secrets."indexer-api-keys/NZBgeek".path;
        }

        # Torrent indexers
        {
          enable = true;
          name = "Nyaa.si";
          baseUrl = "https://nyaa.si/";
          radarr_compatibility = true;
          sonarr_compatibility = true;
        }
        {
          enable = true;
          name = "YTS";
          baseUrl = "https://yts.bz/";
        }
        # {
        #   enable = false;
        #   name = "C411";
        #   apikey._secret = config.sops.secrets."indexer-api-keys/C411".path;
        # }
        {
          enable = false;
          name = "The Pirate Bay";
          baseUrl = "https://thepiratebay.org/";
        }
        {
          enable = false;
          name = "LimeTorrents";
          baseUrl = "https://www.limetorrents.fun/";
        }
        {
          enable = false;
          name = "TorrentDownload";
          baseUrl = "https://www.torrentdownload.info/";
        }
      ];
    };
  };
}
