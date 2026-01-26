{ pkgs, ... }:
{
  programs.chromium = {
    enable = true;
    package = (
      pkgs.chromium.override {
        enableWideVine = true;
      }
    );
    commandLineArgs = [
      "--enable-features=AcceleratedVideoEncoder"
      "--ignore-gpu-blocklist"
      "--enable-zero-copy"
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
    ];
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
    ];
  };
}
