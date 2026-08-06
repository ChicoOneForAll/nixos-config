# Nix daemon configuration: experimental features, substituters, GC.
{ ... }:

{
  nix = {
    channel.enable = false;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "@wheel"
      ];
      # Keep the default public binary cache AND the personal Cachix cache.
      # NOTE: this intentionally mirrors `extra-substituters` /
      # `extra-trusted-public-keys` in flake.nix — the flake settings apply at
      # evaluation/build time, these are written to /etc/nix/nix.conf. Both
      # sides are needed; don't deduplicate one of them.
      substituters = [
        "https://cache.nixos.org/"
        "https://noctalia.cachix.org"
      ];
      trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };

    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
