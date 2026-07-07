{
  config,
  ...
}:
let
  domainName = "${config.hostSpec.hostName}.${config.hostSpec.domain}";
in
{
  # services.resolved.enable = lib.mkForce false;
  services.resolved = {
    settings.Resolve.DNSStubListener = "no";
  };
  services.dnsmasq = {
    enable = true;
    settings = {
      bind-interfaces = true;
      # Don't read /etc/resolv.conf; set upstream explicitly
      no-resolv = true;
      # Never forward plain names (without a dot) upstream
      domain-needed = true;
      # Never forward reverse lookups for private ranges upstream
      bogus-priv = true;
      # Addresses to listen on
      listen-address = [
        "100.109.85.57" # tailscale
      ];
      # Useful for debugging
      log-queries = true;

      local = "/${domainName}/";
      domain = domainName;

      # Upstream DNS servers
      server = [
        "100.100.100.100"
      ];

      # Host records: these resolve from any device using this DNS server
      address = [
        # Wildcard: route domainName and all *.domainName to the local Nginx IP
        "/${domainName}/100.109.85.57"
      ];

    };

  };

}
