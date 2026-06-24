{
  config,
  ...
}:
{
  sops.secrets = {
    "sonarr/api_key" = { };
    "sonarr/password" = { };
    "radarr/api_key" = { };
    "radarr/password" = { };
    "lidarr/api_key" = { };
    "lidarr/password" = { };
    "prowlarr/api_key" = { };
    "prowlarr/password" = { };
    "indexer-api-keys/DrunkenSlug" = { };
    "indexer-api-keys/NZBFinder" = { };
    "indexer-api-keys/NzbPlanet" = { };
    "jellyfin/admin_password" = { };
    "seerr/api_key" = { };
    "sabnzbd/api_key" = { };
    "sabnzbd/nzb_key" = { };
    "sabnzbd/username" = { };
    "sabnzbd/password" = { };
    "usenet/eweka/username" = { };
    "usenet/eweka/password" = { };
    "usenet/eweka/server" = { };
    "usenet/newsgroupdirect/username" = { };
    "usenet/newsgroupdirect/server" = { };
  };

  nixflix = {
    enable = true;

    mediaDir = "/data/media";
    stateDir = "/data/.state";

    # TODO: create user for this?
    mediaUsers = [ "michael" ];

    theme = {
      enable = true;
      # TODO: look at options
      name = "overseerr";
    };

    nginx = {
      enable = true;
      addHostsEntries = true;
    };
    postgres.enable = true;

    # TV Shows
    sonarr = {
      enable = true;
      config = {
        apiKey = {
          _secret = config.sops.secrets."sonarr/api_key".path;
        };
        hostConfig.password = {
          _secret = config.sops.secrets."sonarr/password".path;
        };
      };
    };

    # Movies
    radarr = {
      enable = true;
      config = {
        apiKey = {
          _secret = config.sops.secrets."radarr/api_key".path;
        };
        hostConfig.password = {
          _secret = config.sops.secrets."radarr/password".path;
        };
      };
    };

    # Synchronizes Sonarr and Radarr
    recyclarr = {
      enable = true;
      cleanupUnmanagedProfiles = true;
    };

    # Indexer management
    prowlarr = {
      enable = true;
      config = {
        apiKey = {
          _secret = config.sops.secrets."prowlarr/api_key".path;
        };
        hostConfig.password = {
          _secret = config.sops.secrets."prowlarr/password".path;
        };
        indexers = [
          {
            name = "DrunkenSlug";
            apiKey._secret = config.sops.secrets."indexer-api-keys/DrunkenSlug".path;
          }
          {
            name = "NZBFinder";
            apiKey._secret = config.sops.secrets."indexer-api-keys/NZBFinder".path;
          }
          {
            name = "NzbPlanet";
            apiKey._secret = config.sops.secrets."indexer-api-keys/NzbPlanet".path;
          }
        ];
      };
    };

    # Usenet downloader
    sabnzbd = {
      enable = true;
      settings = {
        misc = {
          api_key._secret = config.sops.secrets."sabnzbd/api_key".path;
          nzb_key._secret = config.sops.secrets."sabnzbd/nzb_key".path;
          username._secret = config.sops.secrets."sabnzbd/username".path;
          password._secret = config.sops.secrets."sabnzbd/password".path;
        };
        servers = [
          {
            name = "Eweka";
            host = config.sops.secrets."usenet/eweka/server".path;
            port = 563;
            username._secret = config.sops.secrets."usenet/eweka/username".path;
            password._secret = config.sops.secrets."usenet/eweka/password".path;
            connections = 20;
            ssl = true;
            priority = 0;
            retention = 3000;
          }
          {
            name = "NewsgroupDirect";
            host = config.sops.secrets."usenet/newsgroupdirect/server".path;
            port = 563;
            username._secret = config.sops.secrets."usenet/newsgroupdirect/username".path;
            password._secret = config.sops.secrets."usenet/newsgroupdirect/password".path;
            connections = 10;
            ssl = true;
            priority = 1;
            optional = true;
            backup = true;
          }
        ];
      };
    };

    # Media streaming, automatic library configuration
    jellyfin = {
      enable = true;
      users.admin = {
        mutable = false;
        policy.isAdministrator = true;
        password = {
          _secret = config.sops.secrets."jellyfin/admin_password".path;
        };
      };
    };

    # Request management
    seer = {
      enable = true;
      apiKey._secret = config.sops.secrets."seerr/api_key".path;
    };

    # Wireguard
    # TODO: configure a wireguard instace with a conf path
    # vpn = {
    #   enable = true;
    #   wgConfFile = config.sops.secrets."wireguard/conf".path;
    #   accessibleFrom = [ "192.168.2.0/24" ];
    # };

  };
}
