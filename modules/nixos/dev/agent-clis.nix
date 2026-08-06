# AI agent CLIs built from upstream flakes:
#   hermes  — NousResearch hermes-agent (minimal build)
#   codex, opencode, antigravity-cli — in ./tools.nix and ./antigravity.nix
{ pkgs, inputs, ... }:

{
  environment.systemPackages = [
    (inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.minimal)
  ];
}
