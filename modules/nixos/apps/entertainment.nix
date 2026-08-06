# Entertainment profile: gaming, media, creative apps.
{ pkgs, ... }:

{
  # Gaming
  programs = {
    gamemode.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };

  environment.systemPackages = with pkgs; [
    # Gaming launchers & tools
    protonup-qt
    heroic
    bottles
    lutris
    mangohud
    vkbasalt

    # Media players & streaming
    gpu-screen-recorder
    spotify
    stremio-linux-shell
    vlc
    audacity
    shortwave
    obs-studio
    ffmpeg

    # Creative & art
    krita
  ];
}
