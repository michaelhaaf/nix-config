{
  pkgs,
  ...
}:
{
  # TODO: figure out how to surround with lib.mkIf without introducting top level config, or whatever
  stylix.targets.librewolf.profileNames = [ "default" ];

  programs.librewolf = {
    enable = true;
    package = pkgs.stable.librewolf;

    policies = {
      BlockAboutConfig = true;
      DefaultDownloadDirectory = "\${home}/downloads";
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
      };
    };
  };
}
