{

  # config,
  ...
}:
{
  programs.rclone = {
    enable = true;
    remotes = {
      gd = {
        config = {
          type = "drive";
          scope = "drive";
          # TODO: attribute "rclone/dg/client_id" missing
          # client_id = config.sops.secrets."rclone/gd/client_id".path;
        };
        secrets = {
          # token = config.sops.secrets."rclone/gd/token".path;
          # client_secret = config.sops.secrets."rclone/gd/client_secret".path;
        };
      };
      od = {
        config = {
          type = "onedrive";
          drive_type = "business";
          # drive_id = config.sops.secrets."rclone/od/drive_id".path;
        };
        secrets = {
          # token = config.sops.secrets."rclone/od/token".path;
        };
      };
    };
  };
}
