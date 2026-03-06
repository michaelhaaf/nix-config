# Configurations that will work on all platforms (linux, darwin, ...?)
{
  config,
  lib,
  pkgs,
  hostSpec,
  ...
}:
{
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [
      "modules/common/host-spec.nix"
      "modules/home"
    ])
    (lib.custom.scanPaths ./.)
  ];

  inherit hostSpec;

  services.ssh-agent.enable = true;

  home = {
    username = lib.mkDefault config.hostSpec.primaryUsername;
    homeDirectory = lib.mkDefault config.hostSpec.home;
    stateVersion = lib.mkDefault "25.11";
    sessionPath = [
      "$HOME/.local/bin"
    ];
    sessionVariables = {
      FLAKE = "$HOME/src/nix/nix-config";
      SHELL = "bash";
    };
  };

  # Packages that don't require custom configuration go here
  home.packages = builtins.attrValues {
    inherit (pkgs)
      asciinema # terminal recorder
      asciinema-agg
      bat
      bc
      btop
      chafa # terminal graphics
      coreutils-full # gnu
      curl
      delta
      dust # du, but more intuitive
      eza
      fastfetch # neofetch replacement
      fd
      gawk
      gnused
      gzip
      jq
      inotify-tools # inotify watches
      iftop
      nmap

      pciutils
      pfetch # system info
      pre-commit # git hooks
      p7zip # compression & encryption

      ripgrep
      rsync
      strace # system process tracer
      tree

      usbutils
      unzip # zip extraction
      unrar # rar extraction
      wordnet # lexical database
      yq # yaml parser

      # Repository management
      hub
      gh
      glab
      act
      codeberg-cli
      ;
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
