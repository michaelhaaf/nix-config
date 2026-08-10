# Development utilities I want across all systems
{
  # inputs,
  lib,
  pkgs,
  # config,
  ...
}:
# let
#   sopsFolder = (toString inputs.nix-secrets) + "/sops";
# in
{
  imports = lib.custom.scanPaths ./.;

  home.packages = lib.flatten [
    (lib.attrValues {
      inherit (pkgs)

        # Repository management
        hub
        glab
        act
        codeberg-cli

        # debuggers
        gdb

        # nix
        nixpkgs-review

        # networking
        nmap

        # diffing
        delta
        difftastic

        # parsers
        yq-go # parser for Yaml and Toml Files, that mirrors jq

        # serial debugging
        screen

        # image OCR TODO: maybe should be somewhere else?
        tesseract
        ocrmypdf

        # standard man pages for linux API
        man-pages
        man-pages-posix
        ;
      inherit (pkgs.unstable)
        devenv # environment manager
        mob # mob programming tool

        bootdev-cli # boot.dev, https://github.com/bootdotdev/bootdev
        ;
    })
  ];

  # TODO: Confused as to whether this was necessary. Commenting out for now.
  # sops.secrets."access-tokens/github" = {
  #   sopsFile = "${sopsFolder}/shared.yaml";
  # };
  #
  # home.sessionVariables = {
  #   GH_TOKEN = config.sops.secrets."access-tokens/github".path;
  # };

  programs.gh = {
    enable = true;
    extensions = with pkgs; [
      gh-classroom
      gh-dash
      gh-f
      # TODO: declare the custom package necessary to build the below from source
      # gh-teacher
      # gh-student
    ];

  };

  home.file.".editorconfig".text = ''
    root = true

    [*]
    end_of_line = lf
    insert_final_newline = true
    indent_style = space
    indent_size = 4

    [*.nix]
    indent_style = space
    indent_size = 2

    [*.lua]
    indent_style = space
    indent_size = 2

    [Makefile]
    indent_style = tab
  '';
}
