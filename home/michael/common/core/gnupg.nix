{
  pkgs,
  ...
}:
{

  programs.gpg = {
    enable = true;
    # TODO: use the config object, or $XDG_DATA_HOME
    homedir = "/home/michael/.local/share/gnupg";
    settings = {
      use-agent = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableBashIntegration = true;
    defaultCacheTtl = 77200;
    # enableSshSupport = true;
    pinentry.package = pkgs.wayprompt;
    extraConfig = ''
      pinentry-program /home/michael/.nix-profile/bin/pinentry
      no-allow-external-cache
      max-cache-ttl 72000
      no-grab
      allow-loopback-pinentry
    '';
  };

  home.packages = [
    pkgs.pinentry-tty
    pkgs.wayprompt
  ];
}
