---
adapted-from: https://github.com/EmergentMind/nix-config/blob/dev/docs/addnewhost.md
---

# Adding A New Host

[README](../README.md) > Adding A New Host

FIXME These steps can and should be streamlined significantly during each roadmap stage. In particular, install from the liveISO rather than installing and then loading the config. I opted to forgo the latter until the config is more mature and I better understand the required process.
FIXME(docs) Needs revision based on hostSpec and nixos/darwin support overhaul

### Requirements

Because this repo relies on a private `nix-secrets` repository input as a flake uri, you must use a NixOS ISO versioned 23.11 or higher so that building the flake prompts for a passphrase.

### In this repo

1. Create a configuration file for the new host at `hosts/nixos/<hostname/default.nix` (replace `nixos` with Darwin if that's what your using). Refer to existing host configs and define the config as needed.
1. Add users to `hosts/common/users/<usern>.nix` if needed
1. Create a host-specific home config for each user that will be accessing the host at `home/<user>/<hostname>.nix`.

### On the new host

1. Boot the new machine into a NixOS live environment and wait for a shell, or for the graphical installer to automatically open if you used a graphical ISO.

1. If in the graphical installer, and open a terminal.
   Confirm the boot process brought up networking successfully and a ip was acquired. Check `ip a`. If no ip was assigned, refer to <https://nixos.org/manual/nixos/stable/#sec-installation-manual-networking>

1. To gain remote access right away, set a temporary password for the root user using `passwd root` and following the prompts. Then from a remote machine, `ssh root@xxx.xxx.xxx.xxx` using the ip printed in step 1.

1. Most of the following steps require root. If you are remoted in from step 2 you should have a root shell. Otherwise, `sudo su`

> IMPORTANT: the code samples below assume installation on the `sda` device. Modify if necessary.
> These are instructions come directly from <https://nixos.org/manual/nixos/stable/#sec-installation-manual-partitioning> with little to no modification.

1. Run the `zfs-impermanence-setup` script, OR, do its steps manually

    for instance, to set up zfs mirroring, perform the steps manually with the
    following adaptations:

    - perform initial `sdisk` and `wipefs` commands on each disk (may need `-f` for `wipefs`)
    - perform partition commands on one disk, then run the following commands to copy them
    over:
        ```
        sgdisk /dev/nvme0n1 -R /dev/nvme1n1
        sgdisk -G /dev/nvme1n1
        ```
    - after creating the initial zfs pool, attach it as a mirror using the following command:
        ```
        zpool attach rpool /dev/nvme0n1p2 /dev/nvme1n1p2
        ```
    - a good reference: https://lowtek.ca/roo/2025/nixos-with-mirrored-zfs-boot-volume/

1. Generate default configs

    `# nixos-generate-config --root /mnt`

1. Edit the config so that we can quickly remote in over ssh after installation.

    ```bash
    # vim /mnt/etc/nixos/configuration.nix
    ```

1. Edit or add the following as needed.

    1. Verify:

       ```nix
       boot.loader.systemd-boot.enable = true;
       boot.loader.efi.canTouchEfiVariables = true;
       ```

    1. Uncomment this line and replace `nixos` with your desired host name:

       ```nix
       # networking.hostname = "nixos";
       ```

    1. Delete or comment out the following lines if the are present.

       ```nix
       # services.xserver.enable = true;

       # services.xserver.displayManager.gdm.enable = true;

       # services.xserver.desktopManager.gnome.enable = true;
       ```

    1. Uncomment the `users.users.alice` section and create a basic user. For example:

    1. Uncomment `services.openssh.enable = true`

    1. At the end of the file, but prior to the final `}`, add the following line:

       `nix.settings.experimental-features = [ "nix-command" "flakes" ];`

1. Do the installation.

    `# nixos-install` and set the root password when prompted.

1. Once installation is complete:

    `# reboot`

1. Sign in with the user you created.
1. In case something goes wrong in the next steps, set the password for the user defined in 15.4. For example: `passwd ta`
1. Create as source directory in the users home and clone the nix-config repo.

    ```bash
    $ mkdir -p ~/src
    $ cd ~/src
    $ nix-shell -p git --run 'git clone https://github.com/michaelhaaf/nix-config.git'
    ```

1. Change to the repo directory and run nix-develop to access the dev shell defined in flake.nix.

    ```bash
    $ cd nix-config
    $ nix develop
    ```

1. Generate an age key on the new host, based on its ssh host key.

    ```bash
    $ cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age
    age00000000000000000000000000000000000000000000000000
    ```

### On a system with access to nix-secrets

1. On a system with access to the nix-secrets repo, add the generated age key as a host key entry to the `nix-secrets/.sops.yaml` file.

    ```yaml
    nix-secrets/.sops.yaml

    ------------------------------

    # pub keys
    keys:
      # ...
      - &hosts:
        - &yournewhostname age00000000000000000000000000000000000000000000000000

    creation_rules:
      - path_regex: secrets.yaml$
        key_groups:
        - age:
        # ...
          - *yournewhostname

    ```

1. Update the keys of the related sops file

    ```bash
    $ sops --config ../nix-secrets/.sops.yaml updatekeys ../nix-secrets/secrets.yaml
    2024/02/09 12:11:05 Syncing keys for file /home/ta/src/nix-secrets/secrets.yaml
    The following changes will be made to the file's groups:
    Group 1
        age00000000000000000000000000000000000000000000000000
        age00000000000000000000000000000000000000000000000000
    +++ age00000000000000000000000000000000000000000000000000
    Is this okay? (y/n):y
    2024/02/09 12:16:54 File /home/ta/src/nix-secrets/secrets.yaml synced with new keys
    ```

1. Commit and push the changes to `nix-secrets` so they will be retrieved when the flake is built on the new host.

### Back on the new host

1. Since we've updated nix-secrets, we'll have to update the flake lock file to ensure that the latest revision is retrieved.

1. Copy the generated hardware config from its default location to the nix-config
   location.

1. Build and switch to the flake:

    ```bash
    $ sudo nixos-rebuild switch --flake .#newhostname`
    ```

1. Once the build is finished build home-manager configs for each user on the system:

    ```bash
    $ home-manager build --flake .#user@newhostname

    ...

    $ home-manager build --flake .#user@newhostname
    ```

1. Commit and push the new hardware-configuration that was copied in step 2

---

[Return to top](#adding-a-new-host)

[README](../README.md) > Adding A New Host
