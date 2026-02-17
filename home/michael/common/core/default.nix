# Configurations that will work on all platforms (linux, darwin, ...?)
{
  config,
  lib,
  pkgs,
  hostSpec,
  ...
}:
let
  platform = if hostSpec.isDarwin then "darwin" else "nixos";
in
{
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [
      "modules/common/host-spec.nix"
      "modules/home"
    ])
    ./${platform}.nix

    ./bash.nix
    ./darwin.nix
    ./direnv.nix
    ./fonts.nix
    ./git.nix
    ./kitty.nix
    ./nixos.nix
    ./neovim.nix
    ./password-store.nix
    ./gnupg.nix
    ./ssh.nix
  ];

  inherit hostSpec;

  services.ssh-agent.enable = true;

  home = {
    username = lib.mkDefault config.hostSpec.primaryUsername;
    homeDirectory = lib.mkDefault config.hostSpec.home;
    stateVersion = lib.mkDefault "24.11";
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
      # terminal recording
      asciinema
      asciinema-agg
      bat

      eza
      fd
      ripgrep

      curl

      pciutils
      pfetch # system info
      pre-commit # git hooks
      p7zip # compression & encryption

      rsync
      tree

      usbutils
      unzip # zip extraction
      unrar # rar extraction
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
