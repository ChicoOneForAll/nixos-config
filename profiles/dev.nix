# Development profile: toolchain, editors, cloud SDKs.
{ ... }:
{
  imports = [
    ../modules/nixos/dev/tools.nix
    ../modules/nixos/dev/antigravity.nix
    ../modules/nixos/dev/agent-clis.nix
    ../modules/nixos/dev/vscode.nix
  ];
}
