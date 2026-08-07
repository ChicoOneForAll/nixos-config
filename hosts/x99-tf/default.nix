{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./gpu.nix
    ./networking.nix
  ];
}
