# TODO: do I bother with this for local? maybe not.
# See https://wiki.nixos.org/wiki/ACME
{
  config,
  ...
}:
let
  domainName = "local.${config.hostSpec.domain}";
in
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@${domainName}";
    certs = {
      "${domainName}" = {
        group = config.services.nginx.group;
        extraDomainNames = [
          "mail.${domainName}"
          "www.${domainName}"
        ];
      };
    };
  };
}
