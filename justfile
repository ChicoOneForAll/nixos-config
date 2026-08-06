# nixos-config workflow commands
# Usage: just <command> [host]
#
#   just rebuild             rebuild the current machine (default host: x99-tf)
#   just rebuild new-laptop  rebuild a different host from this repo
#   just update              update flake inputs (flake.lock)
#   just check               validate/build every host (`nix flake check`)
#   just fmt                 format all Nix source (`nix fmt`, via flake formatter)
#   just fmt-check           verify formatting without changing files
#   just clean               remove GC generations older than 7d
#   just status              list system generations

# Rebuild the system for a given host (default: x99-tf).
rebuild host="x99-tf":
    sudo nixos-rebuild switch --flake ".#{{host}}"

# Update flake inputs (flake.lock).
update:
    nix flake update

# Validate: evaluate + build every host in the registry.
check:
    nix flake check

# Format all tracked Nix source (uses formatter from flake.nix).
fmt:
    nix fmt -- $(git ls-files '*.nix')

# Verify formatting without changing files.
fmt-check:
    nix fmt -- --check $(git ls-files '*.nix')

# Remove old generations (keep last 7 days).
clean:
    sudo nix-collect-garbage --delete-older-than 7d

# Show system generations.
status:
    nixos-rebuild list-generations

# Edit encrypted secrets (auto-decrypts with sops).
secrets-edit:
    nix run nixpkgs#sops -- secrets/secrets.yaml

# View decrypted secrets.
secrets-show:
    nix run nixpkgs#sops -- -d secrets/secrets.yaml

# Re-encrypt secrets after adding SSH keys (updates .sops.yaml).
secrets-rekey:
    nix run nixpkgs#sops -- updatekeys secrets/secrets.yaml