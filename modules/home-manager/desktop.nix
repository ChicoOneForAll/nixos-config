# Niri config — fully managed by Home Manager as category files.
#
# The whole niri setup lives in `niri/*.kdl` and is deployed to
# ~/.config/niri/. `config.kdl` is generated and only contains includes, one
# per category: input, layout, settings, keybinds, window rules and outputs.
#
# Output config is machine-specific: a `output.<hostname>.kdl` file next to
# the shared files is deployed only on that host. Machines without one fall
# back to niri's output auto-detection.
#
# Behavior on existing files:
#   - niriConfig.overwrite = false (default): each file is only created if it
#     does not already exist — hand-tuned local configs are left alone.
#   - niriConfig.overwrite = true: all files are managed via xdg.configFile;
#     pre-existing files are backed up to `*.hm-bak` on first switch.
{
  config,
  lib,
  hostname ? "x99-tf",
  ...
}:

let
  niriDir = toString ./niri;
  sharedFiles = [
    "input.kdl"
    "layout.kdl"
    "settings.kdl"
    "keybinds.kdl"
    "windowsrule.kdl"
  ];
  # Output configuration is host-specific: deploy `output.<hostname>.kdl`
  # only on the machine it was written for.
  hostOutput = "output.${hostname}.kdl";
  outputFiles = lib.optionals (builtins.pathExists "${niriDir}/${hostOutput}") [ hostOutput ];
  files = sharedFiles ++ outputFiles;
  # config.kdl is generated so its includes always match the files deployed.
  configKdl = builtins.toFile "config.kdl" (
    lib.concatStringsSep "\n" (
      [
        "// Niri config — managed by nixos-config via Home Manager."
        "// Split into category files; includes are generated for host '${hostname}'."
        "include \"input.kdl\""
        "include \"layout.kdl\""
        "include \"settings.kdl\""
        "include \"keybinds.kdl\""
        "include \"windowsrule.kdl\""
      ]
      ++ map (f: "include \"${f}\"") outputFiles
    )
    + "\n"
  );
  cfg = config.niriConfig;
in
{
  options.niriConfig = {
    overwrite = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to take over existing files in ~/.config/niri.
        When false, each file is only created if it does not already exist.
        When true, all files are managed by Home Manager and pre-existing
        files are backed up with the hm-bak extension on first switch.
      '';
    };
  };

  config = lib.mkMerge [
    # Override mode: fully Home Manager-managed files.
    (lib.mkIf cfg.overwrite {
      xdg.configFile =
        (builtins.listToAttrs (
          map (f: {
            name = "niri/${f}";
            value.source = "${niriDir}/${f}";
          }) files
        ))
        // {
          "niri/config.kdl".source = configKdl;
        };
    })
    # Skip mode: create each file only if it does not already exist.
    (lib.mkIf (!cfg.overwrite) {
      home.activation.niriConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] (
        let
          links = lib.concatMapStringsSep "\n" (f: ''
            if [[ ! -e "$HOME/.config/niri/${f}" ]]; then
              ln -s "${niriDir}/${f}" "$HOME/.config/niri/${f}"
            fi
          '') files;
        in
        ''
          mkdir -p "$HOME/.config/niri"
          if [[ ! -e "$HOME/.config/niri/config.kdl" ]]; then
            cat "${configKdl}" > "$HOME/.config/niri/config.kdl"
          fi
          ${links}
        ''
      );
    })
  ];
}
