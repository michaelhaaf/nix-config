{
  pkgs,
  ...
}:
{
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (ext: [
      ext.pass-import
      ext.pass-genphrase
      ext.pass-update
      ext.pass-otp
    ]);
  };
}
