{
  inputs,
  nixpkgs,
  home-manager,
}:

let
  lib = nixpkgs.lib;
in
{

  mkHost =
    {
      hostname,
      username ? "chicoarun",
      users ? [ username ],
      system ? "x86_64-linux",
      stateVersion ? "26.11",
      modules ? [ ],
      profiles ? [ ],
    }:
    let
      # Passed to every NixOS + Home Manager module.
      specialArgs = {
        inherit
          inputs
          username
          users
          hostname
          system
          stateVersion
          ;
      };

      # A working home for ANY username: shared modules + per-user
      # username/homeDir/stateVersion. Unknown users get this by default;
      # home/<user>/default.nix — a regular Home Manager module — overrides
      # it for custom setups (it already is the home of that exact user).
      homeUser =
        user:
        let
          homeFile = ../home/${user}/default.nix;
        in
        if builtins.pathExists homeFile then
          import homeFile
        else
          {
            imports = [
              ../modules/home-manager
            ];
            home = {
              username = user;
              homeDirectory = "/home/${user}";
              inherit stateVersion;
            };
          };
    in
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = specialArgs;
      modules =
        modules
        # Always-on base system: users, locale, nix settings, polkit.
        ++ [ ../modules/nixos ]
        # Single source of truth for stateVersion — hosts may override.
        ++ [ { system.stateVersion = lib.mkDefault stateVersion; } ]
        # Optional, composable features chosen per host.
        ++ map (p: ../profiles/${p}.nix) profiles
        ++ [
          # Home Manager — one home per user, all sharing the common modules.
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              # Back up any pre-existing dotfile instead of failing the switch —
              # keeps rebuilds reliable on every machine (first run only).
              backupFileExtension = "hm-bak";
              extraSpecialArgs = specialArgs;
              users = lib.genAttrs users homeUser;
            };
          }
        ];
    };
}
