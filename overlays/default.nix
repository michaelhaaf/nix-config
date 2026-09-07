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

  linuxModifications = final: prev: prev.lib.mkIf final.stdenv.hostPlatform.isLinux { };

  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: let ... in {
    # ...
    # });
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final.stdenv.hostPlatform) system;
      config.allowUnfree = true;
      overlays = [
        # https://github.com/NixOS/nixpkgs/issues/536623#issuecomment-4833056236
        (stable_final: stable_prev: {
          pnpm_10_29_2 = stable_final.pnpm_10;
        })
      ];
    };
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final.stdenv.hostPlatform) system;
      config.allowUnfree = true;
      overlays = [
        (unstable_final: unstable_prev: {
          # https://jezenthomas.com/2026/07/nix-overrides-that-expire-themselves/
          # keeping this here as an example that hopefully works
          # anki = unstable_prev.anki.overrideAttrs (
          #   previousAttrs:
          #   let
          #     version = "26.08.1";
          #     hashes = {
          #       version = "sha256:88785a68b0e361ec173ff38410fe0ee4388b2723da0ef1cf0746c5e862e4a7df";
          #     };
          #     noOverride = _prev.lib.versionAtLeast unstable_prev.anki.version version;
          #   in
          #   _prev.lib.warnIf noOverride
          #     ''
          #       anki >= ${version} is now in nixpkgs, the override should be removed.
          #     ''
          #     rec {
          #       inherit version;
          #       src = _prev.fetchFromGitHub {
          #         owner = "ankitects";
          #         repo = "anki";
          #         tag = "v${version}";
          #         hash = hashes.${version} or "";
          #       };
          #       # vendorHash = "sha256:88785a68b0e361ec173ff38410fe0ee4388b2723da0ef1cf0746c5e862e4a7df";
          #     }
          # );
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
