{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ddcutil
    fastfetch
    ghostty
    pay-respects
    unzip
    xwayland-satellite
    cava
    btop
  ];
}
