# Desktop profile: compositor, shell, IME, wallpapers, desktop utilities.
{ ... }:
{
  imports = [
    ../modules/nixos/desktop/niri.nix
    ../modules/nixos/desktop/noctalia.nix
    ../modules/nixos/desktop/fcitx5.nix
    ../modules/nixos/desktop/wallpapers.nix
    ../modules/nixos/services/utils.nix
  ];
}
