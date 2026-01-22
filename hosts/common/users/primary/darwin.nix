# User config applicable only to darwin
{ config, ... }:
{
  users.users.${config.hostSpec.primaryUsername} = {
    home = "/Users/${config.hostSpec.primaryUsername}";
  };
}
