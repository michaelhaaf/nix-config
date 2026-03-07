{
  lib,
  pkgs,
  ...
}:
{
  # TODO: Some submodule seems to be enabling this?
  services.gnome.gcr-ssh-agent.enable = false;
  programs.ssh = lib.optionalAttrs pkgs.stdenv.isLinux {
    startAgent = true;
    # enableAskPassword = true;
  };
}
