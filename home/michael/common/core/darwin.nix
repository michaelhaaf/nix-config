# Core home functionality that will only work on Darwin
{ config, ... }:
{
  home.sessionPath = [ "/opt/homebrew/bin" ];

  home = {
    username = config.hostSpec.primaryUsername;
    homeDirectory = config.hostSpec.home;
  };
}
