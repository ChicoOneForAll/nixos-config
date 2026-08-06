# Toolchain installed system-wide for every machine that opts into the `dev`
# profile. Version-agnostic aliases are used (jdk, postgresql) instead of pinned
# numbers so a nixpkgs bump never breaks evaluation when a release is dropped.
{ pkgs, ... }:

{
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    gcc
    neovim
    nil
    nixd
    nixfmt
    tree-sitter
    python3
    jdk
    postgresql
    nodejs
    google-cloud-sdk
    codex
    opencode
    just
    git-lfs
  ];

  environment.sessionVariables = {
    JAVA_HOME = pkgs.jdk.home;
  };
}
