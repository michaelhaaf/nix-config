{
  pkgs,
  lib,
  ...
}:
{
  home.packages =
    let
      qrencode = lib.getExe pkgs.qrencode;
      wlCopy = lib.getExe' pkgs.wl-clipboard "wl-copy";
      wlPaste = lib.getExe' pkgs.wl-clipboard "wl-paste";
      zbarimg = lib.getExe' pkgs.zbar "zbarimg";
    in
    [
      pkgs.zbar
      pkgs.qrencode
      # Adapted from https://github.com/hyperparabolic/nix-config
      # helpers for encoding and decoding otp qrs from clipboard for backup
      # TODO: this doesn't really work
      (pkgs.writeShellScriptBin "otpauth-decode-clipboard" ''
        ${wlPaste} | ${zbarimg} -q --raw -
        ${wlCopy} --clear
      '')
      (pkgs.writeShellScriptBin "otpauth-encode-clipboard" ''
        ${wlPaste} | ${qrencode} -m 2 -t utf8
        ${wlCopy} --clear
      '')
    ];
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
