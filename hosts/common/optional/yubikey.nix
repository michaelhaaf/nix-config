{ pkgs, ... }:
{
  # OTP key management
  environment.systemPackages = [ pkgs.yubioath-flutter ];

  services = {
    udev.packages = [ pkgs.yubikey-personalization ];

    # Smart card (CCID) mode
    pcscd.enable = true; # may need to disable-ccid in gnupg home manager, see https://nix-community.github.io/home-manager/options/home-manager/programs/gpg.html#opt-programs.gpg.scdaemonSettings
  };

  # Allows use of yubikey for login/sudo using u2f
  # enrolling the yubikey in advance required, see https://wiki.nixos.org/wiki/Yubikey
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };
}
