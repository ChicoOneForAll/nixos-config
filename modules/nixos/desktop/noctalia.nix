{ inputs, ... }:

{
  imports = [
    inputs.noctalia-greeter.nixosModules.default
  ];

  programs = {
    noctalia = {
      enable = true;
      recommendedServices.enable = true;
      systemd.enable = true;
    };
    noctalia-greeter.enable = true;
  };

  # Gate noctalia.service to only run in niri sessions.
  # Niri sets NIRI_SOCKET, which noctalia relies on for its wayland session.
  systemd.user.services.noctalia.unitConfig.ConditionEnvironment = "NIRI_SOCKET";
}
