{
  stateVersion ? "26.11",
  ...
}:

{
  imports = [
    ../../modules/home-manager
  ];

  home = {
    username = "chicoarun";
    homeDirectory = "/home/chicoarun";
    inherit stateVersion;
  };

  niriConfig.overwrite = true;

}
