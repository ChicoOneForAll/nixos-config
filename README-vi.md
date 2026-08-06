# Cấu Hình NixOS

Cấu hình NixOS đa máy với profiles modular, quản lý secrets declarative, và tích hợp home-manager.

## Bắt Đầu Nhanh

```bash
# Clone repository
git clone https://github.com/ChicoOneForAll/nixos-config.git
cd nixos-config

# Thêm máy mới
sudo nixos-generate-config --dir /tmp/hw
sudo cp /tmp/hw/hardware-configuration.nix hosts/<tên-máy>/

# Build và switch
sudo nixos-rebuild switch --flake .#<tên-máy>
```

## Cấu Trúc

```
.
├── flake.nix              # Entry point chính, registry hosts
├── lib/                   # Hàm builder mkHost
├── hosts/                 # Cấu hình phần cứng từng máy
│   └── <tên-máy>/
│       ├── hardware-configuration.nix
│       ├── boot.nix
│       ├── gpu.nix
│       └── networking.nix
├── profiles/              # Feature profiles có thể kết hợp
│   ├── desktop.nix        # Môi trường desktop
│   ├── dev.nix            # Công cụ phát triển
│   ├── entertainment.nix  # Gaming, media, ứng dụng sáng tạo
│   ├── communication.nix  # Chat, email, nhắn tin
│   ├── productivity.nix   # Ứng dụng văn phòng
│   └── network.nix        # Công cụ mạng
├── modules/
│   ├── nixos/             # Modules cấp hệ thống
│   │   ├── core/          # Hệ thống cơ bản (luôn bật)
│   │   ├── apps/          # Nhóm ứng dụng
│   │   ├── desktop/       # Môi trường desktop
│   │   ├── dev/           # Công cụ phát triển
│   │   └── services/      # Dịch vụ hệ thống
│   └── home-manager/      # Cấu hình môi trường người dùng
├── home/                  # Cấu hình home theo người dùng
│   └── <tên-người-dùng>/
└── scripts/               # Script tiện ích
    └── backup             # Backup các file quan trọng
```

## Thêm Máy Mới

1. Tạo cấu hình phần cứng:
   ```bash
   sudo nixos-generate-config --dir /tmp/hw
   ```

2. Tạo thư mục host:
   ```bash
   mkdir -p hosts/<tên-máy>
   cp /tmp/hw/hardware-configuration.nix hosts/<tên-máy>/
   ```

3. Thêm vào `flake.nix`:
   ```nix
   hosts = {
     <tên-máy> = {
       modules = [ ./hosts/<tên-máy> ];
       profiles = [ "desktop" "dev" "entertainment" ];
     };
   };
   ```

4. Build:
   ```bash
   sudo nixos-rebuild switch --flake .#<tên-máy>
   ```

## Profiles

Chọn profiles dựa trên mục đích sử dụng máy:

- **desktop** - Niri compositor, Noctalia greeter, fcitx5 IME
- **dev** - VSCode, công cụ phát triển, AI coding assistants
- **entertainment** - Gaming (Steam, Heroic), media (VLC, Spotify), sáng tạo (Krita)
- **communication** - Discord, Telegram, email
- **productivity** - Bộ office, công cụ tài liệu
- **network** - Tiện ích và công cụ mạng
- **flatpak** - Hỗ trợ Flatpak

## Quản Lý Secrets

Sử dụng sops-nix với mã hóa age:

1. Tạo age key:
   ```bash
   mkdir -p ~/.config/sops/age
   nix run nixpkgs#age -- -keygen -o ~/.config/sops/age/keys.txt
   ```

2. Thêm public key vào `.sops.yaml`

3. Chỉnh sửa secrets:
   ```bash
   nix run nixpkgs#sops -- secrets/secrets.yaml
   ```

4. Backup age key:
   ```bash
   ./scripts/backup
   ```

**⚠️ QUAN TRỌNG: Không có age key, secrets không thể giải mã. Hãy backup!**

## Lệnh

```bash
# Rebuild máy hiện tại
just rebuild

# Rebuild máy cụ thể
just rebuild <tên-máy>

# Update flake inputs
just update

# Format tất cả file .nix
just fmt

# Backup các file quan trọng
./scripts/backup [thư-mục-backup]
```

## Bảo Mật

- Secrets mã hóa age với sops-nix
- GNOME Keyring cho secrets ứng dụng
- Polkit để quản lý quyền
- Không commit secrets vào git (xem `.gitignore`)

## License

MIT
