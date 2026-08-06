# Flatpak / Flathub sandbox profile.
{ lib, pkgs, ... }:

{
  services.flatpak.enable = true;

  environment.sessionVariables.XDG_DATA_DIRS = lib.mkBefore [
    "/usr/share"
    "/var/lib/flatpak/exports/share"
    "$HOME/.local/share/flatpak/exports/share"
  ];

  environment.systemPackages = [ pkgs.flatpak ];
}
