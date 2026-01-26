{ pkgs, ... }:
{

  security.pam.services.homie = {
    kwallet = {
      enable = true;
      package = pkgs.kdePackages.kwallet-pam;
    };
  };
}
