{
  imports = [
    # Always-on base: users, locale, timezone, nix settings, secrets, polkit.
    # Everything else (desktop, apps, dev, services) is opt-in via profiles.
    ./core/common.nix
    ./core/nix.nix
    ./core/security.nix
    ./core/secrets.nix
    ./apps/core-apps.nix
  ];
}
