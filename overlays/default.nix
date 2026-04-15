#
# This file defines overlays/custom modifications to upstream packages
#

{ inputs, ... }:

let
  # Add in custom packages from this config
  additions =
    final: prev:
    (prev.lib.packagesFromDirectoryRecursive {
      callPackage = prev.lib.callPackageWith final;
      directory = ../pkgs/common;
    });

  linuxModifications = final: prev: prev.lib.mkIf final.stdenv.isLinux { };

  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: let ... in {
    # ...
    # });
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      config.allowUnfree = true;
      #overlays = [
      #];
    };
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
      overlays = [
        (unstable_final: unstable_prev: {
          bootdev-cli = unstable_prev.bootdev-cli.overrideAttrs (
            previousAttrs:
            let
              version = "1.28.0";
              hashes = {
                "1.28.0" = "sha256-sBPId1wEsIG1E+sf+pbqfz0xW0+PHVAoRYTkFLXpWOU=";
              };
            in
            rec {
              inherit version;
              src = _prev.fetchFromGitHub {
                owner = "bootdotdev";
                repo = "bootdev";
                tag = "v${version}";
                hash = hashes.${version} or "";
              };
              vendorHash = "sha256-ZDioEU5uPCkd+kC83cLlpgzyOsnpj2S7N+lQgsQb8uY=";
            }
          );
        })
      ];
    };
  };

in
{
  default =
    final: prev:

    (additions final prev)
    // (modifications final prev)
    // (linuxModifications final prev)
    // (stable-packages final prev)
    // (unstable-packages final prev);
}
