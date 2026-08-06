{
  description = "Multi-machine NixOS configuration";

  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fcitx5-lotus = {
      url = "github:LotusInputMethod/fcitx5-lotus";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hermes-agent = {
      url = "github:NousResearch/hermes-agent";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (import ./lib { inherit inputs nixpkgs home-manager; }) mkHost;
      lib = nixpkgs.lib;

      # ------------------------------------------------------------------
      # Host registry.
      #
      # To add a new machine:
      #   1. Run `nixos-generate-config` and drop `hardware-configuration.nix`
      #      under `hosts/<hostname>/` (plus boot/gpu/networking if needed).
      #   2. Add an entry below.
      #   3. Run `just rebuild <hostname>` (or plain `just rebuild` on the box).
      # ------------------------------------------------------------------
      hosts = {
        x99-tf = {
          modules = [ ./hosts/x99-tf ];
          profiles = [
            "desktop"
            "dev"
            "entertainment"
            "productivity"
            "network"
            "communication"
            "flatpak"
            "9router"
          ];
        };

        # new-laptop = {
        #   username = "chicoarun";
        #   system = "x86_64-linux";
        #   modules = [ ./hosts/new-laptop ];
        #   profiles = [ "desktop" "dev" ];
        # };
      };

      # Build each NixOS configuration by merging its registry entry.
      nixosConfigurations = lib.mapAttrs (name: host: mkHost (host // { hostname = name; })) hosts;

      # Resolve the target platform for each host (defaults to x86_64-linux).
      hostSystems = lib.mapAttrs (_: host: host.system or "x86_64-linux") hosts;
      systems = lib.unique (lib.attrValues hostSystems);

      # `nix flake check` builds / evaluates every host on its own platform.
      checks = lib.genAttrs systems (
        sys:
        lib.mapAttrs' (name: cfg: lib.nameValuePair name cfg.config.system.build.toplevel) (
          lib.filterAttrs (n: _: hostSystems.${n} == sys) nixosConfigurations
        )
      );
    in
    {
      inherit nixosConfigurations checks;

      # Formatter for `nix fmt`.
      formatter = lib.genAttrs systems (sys: nixpkgs.legacyPackages.${sys}.nixfmt);
    };
}
