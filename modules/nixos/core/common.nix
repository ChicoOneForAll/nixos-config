# Base system that runs on every machine: users, locale, nix settings.
# Machine-specific bits (GPU, boot, networking, hardware) live under hosts/<host>/.
{
  lib,
  pkgs,
  username ? "chicoarun",
  users ? [ username ],
  hostname,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;

  security.polkit.enable = true;

  # Locale defaults — individual hosts can extend supportedLocales.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "vi_VN/UTF-8"
  ];
  time.timeZone = lib.mkDefault "Asia/Ho_Chi_Minh";

  # Hostname is derived from the host registry; hosts may override explicitly.
  networking.hostName = lib.mkDefault hostname;

  programs.zsh.enable = true;

  # Create every declared user declaratively (single assignment, no overlaps)
  # so any machine can host any user. The primary user additionally gets
  # administrative + network groups.
  #
  # `initialPassword` bootstraps a working login on fresh installs; NixOS
  # forces the password to be changed on first login.
  users.users = lib.listToAttrs (
    map (
      u:
      lib.nameValuePair u {
        isNormalUser = true;
        shell = pkgs.zsh;
        extraGroups = lib.optionals (u == username) [
          "wheel"
          "networkmanager"
        ];
      }
    ) users
  );

  environment.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    SUDO_EDITOR = "nvim";
  };
}
