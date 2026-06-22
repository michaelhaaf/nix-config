{
  lib,
  stdenv,
  fetchgit,
}:
let
  pname = "pass-fzf";
  version = "4a703e72c0887f2012de8e791e725181d1ce18d8";
  SYSTEM_EXTENSION_DIR = "lib/password-store/extensions";
in

stdenv.mkDerivation {
  inherit pname;
  inherit version;
  inherit SYSTEM_EXTENSION_DIR;

  src = fetchgit {
    url = "https:/github.com/ficoos/pass-fzf";
    ref = "master";
    rev = version;
  };

  dontBuild = true;

  # TODO: actually get this to be put in the extension dir, see here
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/tools/security/pass/default.nix#L45-L81
  installPhase = ''
    install -d $out/${SYSTEM_EXTENSION_DIR}/
    install -m0755 fzf.bash "$out/${SYSTEM_EXTENSION_DIR}/fzf.bash"
  '';

  meta = {
    description = "Fuzzy finder for pass";
    homepage = "https://github.com/ficoos/pass-fzf";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
