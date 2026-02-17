{
  pkgs,
  ...
}:
{

  programs.gpg = {
    enable = true;
    # TODO: use the config object, or $XDG_DATA_HOME
    homedir = "/home/michael/.local/share/gnupg";
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry-tty;
  };

  home.packages = [
    pkgs.pinentry-tty
  ];
}
