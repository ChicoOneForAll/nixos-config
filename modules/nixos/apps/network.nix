# Network profile: download and share tools.
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    qbittorrent
    aria2
    yt-dlp
  ];
}
