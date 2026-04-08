{
  # inputs,
  pkgs,
  config,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    arion
    compose2nix
  ];
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    daemon.settings = {
      userland-proxy = false;
      # TODO: configure for Impermanence
      # data-root = "/persist/";
    };
  };
  users.users.${config.hostSpec.primaryUsername} = {
    extraGroups = [ "docker" ];
  };
}
