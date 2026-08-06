{ pkgs, ... }:

{
  programs = {
    yazi = {
      enableZshIntegration = true;
      shellWrapperName = "y";
    };
  };
}
