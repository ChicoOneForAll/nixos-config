{ pkgs, ... }:

{
  nixpkgs.config.rocmSupport = true;

  hardware = {
    amdgpu = {
      opencl.enable = true;
      overdrive.enable = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
        mesa.opencl
      ];
    };
  };

  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
  };

  environment = {
    variables.ROC_ENABLE_PRE_VEGA = "1";
    systemPackages = with pkgs; [ lact ];
  };

  systemd = {
    packages = with pkgs; [ lact ];
    services.lactd.wantedBy = [ "multi-user.target" ];
    tmpfiles.rules = [
      "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"
    ];
  };
}
