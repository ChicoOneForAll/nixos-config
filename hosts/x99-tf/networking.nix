{ ... }:

{
  networking = {
    nameservers = [
      "127.0.0.1"
      "::1"
      "9.9.9.9"
    ];
    networkmanager = {
      enable = true;
      dns = "none";
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [ 53317 ];
      allowedUDPPorts = [ 53317 ];
    };
  };

  services = {
    resolved.enable = false;

    dnscrypt-proxy = {
      enable = true;
      settings = {
        server_names = [ "sdns" ];
        static.sdns.stamp = "sdns://AgcAAAAAAAAAAAAYc2Rucy5jaGljb2FydW4uZHBkbnMub3JnCi9kbnMtcXVlcnk";
      };
    };
  };
}
