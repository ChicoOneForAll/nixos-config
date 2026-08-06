# Desktop profile: compositor, shell, IME, wallpapers, desktop utilities.
# Niri + Noctalia only.
{ ... }:
{
  imports = [
    # Niri compositor + Noctalia shell
    ../modules/nixos/desktop/niri.nix
    ../modules/nixos/desktop/noctalia.nix

    # Shared components
    ../modules/nixos/desktop/fcitx5.nix
    ../modules/nixos/desktop/wallpapers.nix
    ../modules/nixos/services/utils.nix
  ];
}
