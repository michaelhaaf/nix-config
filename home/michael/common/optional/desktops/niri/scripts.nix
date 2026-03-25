{
  pkgs,
  ...
}:
let

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
  # ========== Generate Settings Diff ==========
  #
  # Designed to be used to generate a diff against initial settings in .nix format for easy adaptation
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

in
{
  home.packages = [
    saveSettings
    generateSettingsDiff
  ];
}
