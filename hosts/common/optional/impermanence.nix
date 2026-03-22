{ inputs, lib, ... }:
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    # 1. Wait for LUKS (no luks, shouldn't be necessary)
    udevadm settle
    # 2. Force the pool into the "garage"
    zpool import -f -N rpool
    # 3. Clean the slate
    zfs rollback -r rpool/local/root@blank
    # 4. Give the pool back to the system
    zpool export rpool
  '';

  environment.persistence."/persist" = {
    directories = lib.flatten [
      # "/var/lib/sbctl"
      "/etc/NetworkManager/system-connections" # This is where Wi-Fi/Ethernet profiles live
      "/var/lib/bluetooth" # While you're at it, keep your Bluetooth pairs
      "/var/lib/nixos" # Keeps track of UID/GIDs
      "/var/lib/systemd/coredump"
      "/var/log"
      # systemd DynamicUser requires /var/{lib,cache}/private to exist and be 0700
      {
        directory = "/var/lib/private";
        mode = "0700";
      }
      {
        directory = "/var/cache/private";
        mode = "0700";
      }
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"

      # Non-essential
      "/root/.ssh/known_hosts"
    ];
  };
}
