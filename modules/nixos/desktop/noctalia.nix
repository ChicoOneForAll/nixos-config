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
}
