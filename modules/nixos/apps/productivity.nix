# Productivity profile: notes, passwords, file sharing.
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    obsidian
    keepass
    bitwarden-desktop
    localsend
  ];
}
