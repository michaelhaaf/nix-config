# TODO: adapt this further to re-use the existing build logic (e.g. in the scripts dir)
# Adapted from: https://github.com/basnijholt/dotfiles/blob/main/configs/nixos/hosts/nix-cache/auto-build.nix

# TODO: bootstrap the initial ssh auth for github somewhere (needs to run once because of Authenticity of Host warning)

# Automatic nix build service for caching
{ pkgs, ... }:

{
  systemd = {
    # --- Auto-Build Service ---
    services.nix-auto-build = {
      description = "Build and cache NixOS configurations";
      path = with pkgs; [
        git
        nix
        openssh
        jq
        uv
        python3
      ];
      script = ''
        set -euo pipefail
        export NIX_REMOTE=daemon

        DOTFILES="/var/lib/nix-auto-build/nix-config"

        # Clone or update dotfiles
        if [ ! -d "$DOTFILES" ]; then
          git clone git+ssh://git@github.com/michaelhaaf/nix-config.git "$DOTFILES"
        fi

        cd "$DOTFILES"

        # Update flake inputs
        nix flake update

        # Get the commit ID of the nixpkgs input (locked in flake.lock)
        COMMIT_ID=$(jq -r .nodes.nixpkgs.locked.rev flake.lock)

        # Build all host configurations
        for host in laptop minerva htpc; do
          echo "Building $host..."
          if nix build .#nixosConfigurations.$host.config.system.build.toplevel \
            --out-link "/var/lib/nix-auto-build/result-$host" \
            --print-out-paths; then
              echo "$COMMIT_ID" > "/var/lib/nix-auto-build/$host.rev"
          else
              echo "Warning: $host build failed, continuing..."
          fi
        done

        echo "All builds completed at $(date)"
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        # Generous timeout for CUDA builds
        TimeoutStartSec = "3d";
      };
    };

    # --- Daily Timer ---
    timers.nix-auto-build = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*-*-* 02:00:00";
        Persistent = true;
        RandomizedDelaySec = "1h";
      };
    };

    # Ensure build directory exists
    tmpfiles.rules = [
      "d /var/lib/nix-auto-build 0755 root root -"
    ];
  };
}
