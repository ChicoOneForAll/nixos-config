{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (vscode.override {
      commandLineArgs = [
        "--password-store=gnome-libsecret"
      ];
    })
  ];

  # gnome-keyring is enabled in core/security.nix
}
