# HACK: this is all hard-coded to ghost until KDL and nix interplay nicely or I adopt a
# something some sort of wrapper.... another rabbit hole
# as of 26.01.24 the `power-off-monitor` actions listed by `niri msg action`
# haven't actually been implemented in the src:
# `https://github.com/YaLTeR/niri/blob/d7184a04b904e07113f4623610775ae78d32394c/niri-ipc/src/lib.rs#L202`

{
  pkgs,
  ...
}:
let

  #
  # ========== Toggle All Monitors ==========
  #
  # Toggle on/off all monitors. Toggle on all monitors if _any_ monitor is off.

  # TODO(niri):requisite niri actions not yet available

  #
  # ========== Toggle Gaming Mode ==========
  #
  # Toggle on/off all non-primary monitors (gaming mode)

  # TODO(niri):requisite niri actions not yet available

  #
  # ========== Store Settings Hook ==========
  #
  # Designed to be used as a start-up hook to store the initial noctalia settings.
  saveSettings = pkgs.writeShellApplication {
    name = "saveSettings";
    text = ''
      #!/usr/bin/env bash
      mkdir -p "/tmp/noctalia-cache"
      noctalia-shell ipc call state all | jq .settings > "/tmp/noctalia-cache/settings.json"
    '';
  };

  #
  # ========== Store Settings Hook ==========
  #
  # Designed to be used as a start-up hook to store the initial noctalia settings.
  generateSettingsDiff = pkgs.writeShellApplication {
    name = "generateSettingsDiff";
    text = ''
      #!/usr/bin/env bash
      mkdir -p "/tmp/noctalia-cache"

      # || true because json-diff always returns exit code 1 for some reason
      # github.com/andreyvit/json-diff/issues/130
      json-diff -nj <(jq -S . "/tmp/noctalia-cache/settings.json") <(noctalia-shell ipc call state all  | jq -S .settings) > "/tmp/noctalia-cache/diff.json" || true
      if [ -s "/tmp/noctalia-cache/diff.json" ]; then
        nix eval --impure --expr "builtins.fromJSON (builtins.readFile \"/tmp/noctalia-cache/diff.json\")" | nixfmt > "/tmp/noctalia-cache/diff.nix"
        noctalia-shell ipc call toast send '{"title":"Settings diff saved."}'
      else
        noctalia-shell ipc call toast send '{"title":"No settings changes detected."}'
      fi
    '';
  };

  #
  # ========== Toggle Zen Mode ==========
  #
  # Toggle workspaces on all non-primary monitors between default and empty
  toggleMonitorZen = pkgs.writeShellApplication {
    name = "toggleMonitorZen";
    text = ''
      #!/bin/bash
      niri msg action focus-monitor "DP-2" &&
      niri msg action focus-workspace 2 &&
      niri msg action focus-monitor "DP-3" &&
      niri msg action focus-workspace 2 &&
      niri msg action focus-monitor "HDMI-A-1" &&
      niri msg action focus-workspace 2 &&
      niri msg action focus-monitor "DP-1"
    '';
  };

in
{
  home.packages = [
    toggleMonitorZen
    saveSettings
    generateSettingsDiff
  ];
}
