# Core functionality for every nixos host
{ config, lib, ... }:
{
  # Database for aiding terminal-based programs
  environment.enableAllTerminfo = true;
  # Enable firmware with a license allowing redistribution
  hardware.enableRedistributableFirmware = true;

  # This should be handled by config.security.pam.sshAgentAuth.enable
  security.sudo.extraConfig = ''
    Defaults lecture = never # rollback results in sudo lectures after each reboot, it's somewhat useless anyway
    Defaults pwfeedback # password input feedback - makes typed password visible as asterisks
    Defaults timestamp_timeout=120 # only ask for password every 2h
    # Keep SSH_AUTH_SOCK so that pam_ssh_agent_auth.so can do its magic.
    Defaults env_keep+=SSH_AUTH_SOCK
  '';

  #
  # ========== Nix Helper ==========
  #
  # Provide better build output and will also handle garbage collection in place of standard nix gc (garbace collection)
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 20d --keep 20";
    # `config.hostSpec.home` will be `/home/foo/`, or `/Users/foo/` if you are on Darwin.
    flake = "${config.hostSpec.home}/nix-config";
  };

  #
  # ========== Localization ==========
  #
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  time.timeZone = lib.mkDefault "America/Montreal";

  # TODO: Sysrq, choose a more precise value
  boot.kernel.sysctl."kernel.sysrq" = 1;

  # CPU and RAM limiting for nix builds to prevent 100% CPU and/or OOM during builds and updates.
  # Adapted from: https://discourse.nixos.org/t/nix-build-ate-my-ram/35752
  # And: https://gitlab.com/yajoman/minfra/-/commit/b3602cb9e4e7140de439d8f863f8e8b428497d52
  # DOCS: https://www.freedesktop.org/software/systemd/man/latest/systemd.resource-control.html
  # DOCS: https://discourse.nixos.org/t/nix-build-ate-my-ram/35752?u=yajo
  systemd = {
    # Create a separate slice for nix-daemon that is
    # memory-managed by the userspace systemd-oomd killer
    slices."nix-daemon".sliceConfig = {
      CPUAccounting = true;
      CPUQuota = "50%";
      MemoryAccounting = true; # Allow to control with systemd-cgtop
      MemoryHigh = "50%";
      MemoryMax = "75%";
      MemorySwapMax = "50%";
      MemoryZSwapMax = "50%";
      ManagedOOMMemoryPressure = "kill";
      ManagedOOMMemoryPressureLimit = "50%";
    };
    services."nix-daemon".serviceConfig.Slice = "nix-daemon.slice";
    services.nixos-upgrade.serviceConfig.Slice = "nix-daemon.slice";

    # If a kernel-level OOM event does occur anyway,
    # strongly prefer killing nix-daemon child processes
    services."nix-daemon".serviceConfig.OOMScoreAdjust = 1000;
  };
}
