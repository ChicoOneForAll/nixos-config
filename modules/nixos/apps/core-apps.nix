# Core applications: file manager, browser, version control.
{ pkgs, ... }:

{
  programs = {
    yazi = {
      enable = true;
    };

    git = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    brave
    yazi
    git
  ];
}
