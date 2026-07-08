# `nix-config/hosts/common/core/`: settings that will occur across all hosts

# IMPORTANT: This is used by NixOS and nix-darwin so options must exist in both!
{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  isDarwin,
  ...
}:
let
  sopsFolder = toString inputs.nix-secrets + "/sops";
  platform = if isDarwin then "darwin" else "nixos";
  platformModules = "${platform}Modules";
in
{
  imports = lib.flatten [
    inputs.home-manager.${platformModules}.home-manager
    inputs.sops-nix.${platformModules}.sops

    (map lib.custom.relativeToRoot [
      "modules/common"
      "modules/hosts/common"
      "modules/hosts/${platform}"
      "hosts/common/core/${platform}.nix"
      "hosts/common/core/sops.nix" # Core because it's used for backups, mail
      "hosts/common/core/ssh.nix"
      "hosts/common/core/services" # uncomment this line if you add any modules to services directory
      "hosts/common/users/primary"
      "hosts/common/users/primary/${platform}.nix"
    ])
  ];

  #
  # ========== Core Host Specifications ==========
  #
  # modify the hostSpec options below to define values that are common across all hosts
  # such as the username and handle of the primary user (see also `nix-config/hosts/common/users/primary`)
  hostSpec = {
    primaryUsername = "michael";
    users = [ "michael" ];
    handle = "michaelhaaf";
    inherit (inputs.nix-secrets)
      domain
      email
      userFullName
      ;
  };

  networking.hostName = config.hostSpec.hostName;

  # System-wide packages, in case we log in as root
  environment.systemPackages = [ pkgs.openssh ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bk";
    overwriteBackup = true;
  };

  #
  # ========== Overlays ==========
  #
  nixpkgs = {
    overlays = [
      outputs.overlays.default
    ];
    config = {
      allowUnfree = true;
      # TODO: This didn't work on its own, also needed:
      # export NIXPKGS_ALLOW_UNFREE=1
      # export NIXPKGS_ALLOW_INSECURE=1
      # before nix-shell -p ventoy-full worked.
      # TODO: find a way to add exceptions that sucks less e.g. librewolf
      permittedInsecurePackages = [
        "ventoy-1.1.10"
        "librewolf-151.0.2-1"
        "librewolf-unwrapped-151.0.2-1"
      ];
    };
  };

  sops.secrets."access-tokens/github-nix" = {
    sopsFile = "${sopsFolder}/shared.yaml";
  };

  sops.templates."access-tokens/github-nix.conf".content = ''
    access-tokens = github.com=${config.sops.placeholder."access-tokens/github-nix"}
  '';

  #
  # ========== Nix Nix Nix ==========
  #
  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    extraOptions = ''
      !include ${config.sops.templates."access-tokens/github-nix.conf".path}
    '';

    settings = {
      # See https://jackson.dev/post/nix-reasonable-defaults/
      connect-timeout = 5;
      log-lines = 25;
      min-free = 128000000; # 128MB
      max-free = 1000000000; # 1GB

      trusted-users = [ "@wheel" ];

      # Deduplicate and optimize nix store
      auto-optimise-store = true;

      warn-dirty = false;

      allow-import-from-derivation = true;

      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
        "pipe-operators"
      ];

      builders-use-substitutes = true;
      fallback = true;
      substituters = [
        "https://cache.nixos.org" # Official global cache
        "https://nix-community.cachix.org" # Community packages
        "https://cache.minerva.michaelhaaf.net" # My cache
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.minerva.michaelhaaf.net:/6R5lN0QcixiKt25poOVX/qSBA5wQaRgYMvGQTS7HuM="
      ];
    };
  };
}
