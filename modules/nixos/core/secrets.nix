# Secrets management with sops-nix.
#
# Secrets are encrypted with age and stored in secrets/secrets.yaml.
# Each secret is made available at runtime as a file in /run/secrets/<key>.
#
# Usage:
#   1. Edit secrets:     just secrets-edit
#   2. Access in config: config.sops.secrets.<key>.path
#   3. Re-key after key changes: just secrets-rekey
#
# Key model (this machine):
#   The age identity lives at ~/.config/sops/age/keys.txt (user home).
#   sops-nix reads it via age.keyFile. No SSH host keys are required,
#   so this works on any machine regardless of sshd setup.
{
  inputs,
  config,
  username ? "chicoarun",
  ...
}:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;

    # Age identity used to decrypt secrets at activation time.
    # Pointed at the user key in $HOME (back it up!).
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";

    # Define secrets - each becomes available at /run/secrets/<name>.
    # (No secrets currently registered; rclone was removed.)
  };
}
