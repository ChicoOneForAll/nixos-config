# Git identity configuration (home-manager layer only).
#
# Defaults use `mkDefault`, so any user can override their own identity in
# `home/<username>/default.nix` without forking the shared module.
{ lib, ... }:

{
  programs.git.settings.user = {
    name = lib.mkDefault "ChicoOneForAll";
    email = lib.mkDefault "chicoarun@tutamail.com";
  };
}
