# TODO: do I bother with this for local? maybe not.
# See https://wiki.nixos.org/wiki/ACME
{
  config,
  ...
}:
let
  domainName = "${config.hostSpec.hostName}.${config.hostSpec.domain}";
in
{
  sops.secrets."acme/CF_DNS_API_TOKEN" = { };
  security.acme = {
    acceptTerms = true;
    defaults = {
      dnsProvider = "cloudflare";
      email = "michael.haaf@gmail.com";
      credentialFiles = {
        CLOUDFLARE_DNS_API_TOKEN_FILE = config.sops.secrets."acme/CF_DNS_API_TOKEN".path;
      };
    };
    certs = {
      "${domainName}" = {
        domain = "*.${domainName}";
        extraLegoFlags = [ "--dns.propagation-wait=60s" ];
        group = config.services.nginx.group;
      };
    };
  };
}
