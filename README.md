# NixOS Configuration

[English](README.md) | [Tiếng Việt](README-vi.md)

Multi-machine NixOS configuration with modular profiles, declarative secrets management, and home-manager integration.

## Quick Start

```bash
# Clone the repository
git clone https://github.com/ChicoOneForAll/nixos-config.git
cd nixos-config

# Add new machine
sudo nixos-generate-config --dir /tmp/hw
sudo cp /tmp/hw/hardware-configuration.nix hosts/<hostname>/

# Build and switch
sudo nixos-rebuild switch --flake .#<hostname>
```

## Structure

```
.
├── flake.nix              # Main entry point, host registry
├── lib/                   # mkHost builder function
├── hosts/                 # Per-machine hardware configs
│   └── <hostname>/
│       ├── hardware-configuration.nix
│       ├── boot.nix
│       ├── gpu.nix
│       └── networking.nix
├── profiles/              # Composable feature profiles
│   ├── desktop.nix        # Desktop environment
│   ├── dev.nix            # Development tools
│   ├── entertainment.nix  # Gaming, media, creative apps
│   ├── communication.nix  # Chat, email, messaging
│   ├── productivity.nix   # Office apps
│   └── network.nix        # Network tools
├── modules/
│   ├── nixos/             # System-level modules
│   │   ├── core/          # Base system (always enabled)
│   │   ├── apps/          # Application groups
│   │   ├── desktop/       # Desktop environment
│   │   ├── dev/           # Development tools
│   │   └── services/      # System services (9router, utils)
│   └── home-manager/      # User environment configs
├── home/                  # Per-user home configurations
│   └── <username>/
└── scripts/               # Utility scripts
    └── backup             # Backup critical files
```

## Adding a New Machine

1. Generate hardware config:
   ```bash
   sudo nixos-generate-config --dir /tmp/hw
   ```

2. Create host directory:
   ```bash
   mkdir -p hosts/<hostname>
   cp /tmp/hw/hardware-configuration.nix hosts/<hostname>/
   ```

3. Add to `flake.nix`:
   ```nix
   hosts = {
     <hostname> = {
       modules = [ ./hosts/<hostname> ];
       profiles = [ "desktop" "dev" "entertainment" ];
     };
   };
   ```

4. Build:
   ```bash
   sudo nixos-rebuild switch --flake .#<hostname>
   ```

## Profiles

Choose profiles based on machine purpose:

- **desktop** - Niri compositor, Noctalia greeter, fcitx5 IME
- **dev** - VSCode, development tools, AI coding assistants
- **entertainment** - Gaming (Steam, Heroic), media (VLC, Spotify), creative (Krita)
- **communication** - Discord, Telegram, email clients
- **productivity** - Office suite, document tools
- **network** - Network utilities and tools
- **flatpak** - Flatpak support
- **9router** - Free AI gateway & token saver (Docker, port 20128)

## Secrets Management

Uses sops-nix with age encryption:

1. Generate age key:
   ```bash
   mkdir -p ~/.config/sops/age
   nix run nixpkgs#age -- -keygen -o ~/.config/sops/age/keys.txt
   ```

2. Add public key to `.sops.yaml`

3. Edit secrets:
   ```bash
   nix run nixpkgs#sops -- secrets/secrets.yaml
   ```

4. Backup age key:
   ```bash
   ./scripts/backup
   ```

**⚠️ CRITICAL: Without the age key, secrets cannot be decrypted. Back it up!**

## Commands

```bash
# Rebuild current machine
just rebuild

# Rebuild specific machine
just rebuild <hostname>

# Update flake inputs
just update

# Format all .nix files
just fmt

# Backup critical files
./scripts/backup [backup-dir]
```

## Security

- Age-encrypted secrets with sops-nix
- GNOME Keyring for application secrets
- Polkit for privilege management
- No secrets committed to git (see `.gitignore`)
