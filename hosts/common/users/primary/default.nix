# NOTE(starter): this is the primary user across all hosts. The username for primary is defined in hostSpec,
# and is declared in `nix-config/common/core/default.nix`

# User config applicable to both nixos and darwin
{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  hostSpec = config.hostSpec;
  pubKeys = lib.attrsets.attrValues inputs.nix-secrets.ssh;
in
{
  users.users.${hostSpec.primaryUsername} = {
    name = hostSpec.primaryUsername;
    shell = pkgs.bash; # default shell

    # These get placed into /etc/ssh/authorized_keys.d/<name> on nixos
    openssh.authorizedKeys.keys = pubKeys;
  };

  # Create ssh sockets directory for controlpaths when homemanager not loaded (i.e. isMinimal)
  systemd.tmpfiles.rules =
    let
      user = config.users.users.${hostSpec.primaryUsername}.name;
      group = config.users.users.${hostSpec.primaryUsername}.group;
    in
    # you must set the rule for .ssh separately first, otherwise it will be automatically created as root:root and .ssh/sockects will fail
    [
      "d /home/${hostSpec.primaryUsername}/.ssh 0750 ${user} ${group} -"
      "d /home/${hostSpec.primaryUsername}/.ssh/sockets 0750 ${user} ${group} -"
    ];

  # No matter what environment we are in we want these tools
  programs.zsh.enable = true;
  environment.systemPackages = [
    pkgs.just
    pkgs.rsync
  ];
}
# Import the user's personal/home configurations, unless the environment is minimal
// lib.optionalAttrs (inputs ? "home-manager") {
  home-manager = {
    extraSpecialArgs = {
      inherit pkgs inputs;
      hostSpec = config.hostSpec;
    };
    users.${hostSpec.primaryUsername}.imports = lib.flatten (
      lib.optional (!hostSpec.isMinimal) [
        (
          { config, ... }:
          import (lib.custom.relativeToRoot "home/${hostSpec.primaryUsername}/${hostSpec.hostName}.nix") {
            inherit
              pkgs
              inputs
              config
              lib
              hostSpec
              ;
          }
        )
      ]
    );
  };
}
