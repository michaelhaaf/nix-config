{
  config,
  pkgs,
  ...
}:
let
  homeDir = config.home.homeDirectory;
in
{
  # Inspiration:
  # - https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265/20
  # - https://github.com/gvolpe/nix-config/blob/6feb7e4f47e74a8e3befd2efb423d9232f522ccd/home/programs/browsers/firefox.nix
  # - https://github.com/lucidph3nx/nixos-config/blob/2e42a40cc8d93c25e01dcbe0dacd8de01f4f0c16/modules/home-manager/firefox/default.nix
  # - https://github.com/Kreyren/nixos-config/blob/bd4765eb802a0371de7291980ce999ccff59d619/nixos/users/kreyren/home/modules/web-browsers/firefox/firefox.nix#L116-L148
  #
  # TODO(firefox):
  # - Port bookmarks and other profile settings over from existing profile
  home.packages = with pkgs; [
    tridactyl-native
  ];
  xdg.configFile."tridactyl/tridactylrc".source = ./tridactylrc;
  programs.firefoxpwa = {
    enable = true;
  };
  programs.firefox = {
    enable = true;

    nativeMessagingHosts = [
      pkgs.firefoxpwa
      pkgs.tridactyl-native
    ];
    # Refer to https://mozilla.github.io/policy-templates or `about:policies#documentation` in firefox
    policies = {
      AppAutoUpdate = false;
      BackgroundAppUpdate = false;
      DefaultDownloadDirectory = "${config.home.homeDirectory}/downloads";
      DisableBuiltinPDFViewer = false;
      DisableFirefoxStudies = true;
      DisableFirefoxAccounts = false; # Enable Firefox Sync
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
        # Exceptions = ["https://example.com"]
      };
      ExtensionUpdate = false;
      DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
      DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
      SearchBar = "unified"; # alternative: "separate"

      # To copy extensions from an existing profile you can do something like this:
      # cat ~/.mozilla/firefox/fb8sickr.default/extensions.json | jq '.addons[] | [.defaultLocale.name, .id]'
      #
      # To add additional extensions, find it on addons.mozilla.org, find
      # the short ID in the url (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
      # Then, download the XPI by filling it in to the install_url template, unzip it,
      # run `jq .browser_specific_settings.gecko.id manifest.json` or
      # `jq .applications.gecko.id manifest.json` to get the UUID
      ExtensionSettings =
        let
          extension = shortId: uuid: {
            name = uuid;
            value = {
              install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
              installation_mode = "normal_installed";
            };
          };
        in
        builtins.listToAttrs [

          # To find Extension ID of installed add-on: about:debugging#/runtime/this-firefox
          (extension "ublock-origin" "uBlock0@raymondhill.net")
          (extension "sponsorblock" "sponsorBlocker@ajay.app")
          (extension "pwas_for_firefox" "firefoxpwa@filips.si")
          (extension "tree-style-tab" "treestyletab@piro.sakura.ne.jp")
          (extension "tridactyl" "tridactyl.vim@cmcaine.co.uk")
        ];
      Cookies = {
        Allow = [
          "http://127.0.0.1"
          "https://127.0.0.1"
          "http://localhost"
          "https://localhost"

          # repositories
          "https://github.com"
          "https://gitlab.com"
          "https://codeberg.org"
          "https://sr.ht"

          # utilities
          "https://duckduckgo.com"

          # TODO: make a separate firefox profile for streaming stuff?
          "https://youtube.com"
          "https://music.youtube.com"
          "https://dropout.tv"
          "https://crave.ca"
          "https://netflix.com"

          # TODO: make a separate firefox profile for comms stuff?
          "https://web.whatsapp.com"

          # work TODO: move elsewhere
          "https://johnabbott.omnivox.ca/"
          "https://moodle.johnabbott.qc.ca/"
          "https://login.microsoft.com"
        ];
      };

    };

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      search = {
        force = true;
        default = "ddg";
        order = [ "ddg" ];
      };

      # FIXME(firefox): These should probably be in a let .. in block so I can re-use if I setup
      # additional profiles
      # Should check ~/.mozilla/firefox/PROFILE_NAME/prefs.js | user.js
      # from your old profiles too
      settings = {
        "signon.rememberSignons" = false; # Disable built-in password manager
        "browser.compactmode.show" = true;
        "browser.uidensity" = 1; # enable compact mode
        "browser.aboutConfig.showWarning" = false;
        "browser.download.dir" = "${homeDir}/downloads";
        "browser.contentblocking.category" = "strict";
        "browser.topsites.contile.enabled" = false;
        "browser.formfill.enable" = false;
        "browser.search.suggest.enabled" = false;
        "browser.search.suggest.enabled.private" = false;
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.showSearchSuggestionsFirst" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.snippets" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.system.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.tabs.firefox-view" = false;
        "ui.systemUsesDarkTheme" = 1;
        "extensions.pocket.enabled" = false;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "layout.css.has-selector.enabled" = true;
      };
      containers = {
        work = {
          name = "work";
          color = "yellow";
          icon = "circle";
          id = 1;
        };
      };

      # This just uses the default suggestion from home-manager for now
      userChrome = ''
        /* Hide tab bar in FF Quantum */
        #TabsToolbar {
          visibility: collapse !important;
        }

        #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
          visibility: collapse !important;
        }

        .tabbrowser-tab[usercontextid] .tab-bottom-line {
          display: none !important;
        }
      '';
    };
  };
  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "firefox.desktop" ];
    "text/xml" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
  };
  stylix.targets.firefox.enable = true;
  stylix.targets.firefox.profileNames = [ "default" ];
}
