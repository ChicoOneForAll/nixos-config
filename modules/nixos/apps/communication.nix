# Communication profile: messaging, e-mail, voice/video calls.
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    vesktop
    thunderbird
    telegram-desktop
    signal-desktop
    zoom-us
    element-desktop
  ];
}
