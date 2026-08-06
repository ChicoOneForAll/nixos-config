{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    awww
    mpvpaper
  ];
}
