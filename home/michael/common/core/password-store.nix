{
  pkgs,
  ...
}:
{
  # TODO: pull password store from remote git repo
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (ext: [
      ext.pass-import
      ext.pass-genphrase
      ext.pass-update
      ext.pass-otp
    ]);
    settings = {
      # TODO: use the config object instead, or $XDG_DATA_HOME
      PASSWORD_STORE_DIR = "/home/michael/.local/share/password-store";
    };
  };
}
