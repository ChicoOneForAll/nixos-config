# 9Router — Free AI router with smart fallback for multiple LLM
# providers (OpenAI-compatible, dashboard on port 20128).
# Runs decolua/9router as a systemd-managed container (auto-restart).
{ ... }:

{
  virtualisation.docker.enable = true;

  virtualisation.oci-containers = {
    backend = "docker";
    containers."9router" = {
      image = "decolua/9router:latest@sha256:f23243105cab452e64000e7cf8067a3ff920b7de4142743af4bde78126540015";
      autoStart = true;
      ports = [ "127.0.0.1:20128:20128" ];
      volumes = [ "/var/lib/9router:/app/data" ];
      environment = {
        DATA_DIR = "/app/data";
      };
      extraOptions = [ "--stop-timeout=40" ];
    };
  };
}
