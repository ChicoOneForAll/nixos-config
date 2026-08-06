{ pkgs, ... }:

{
  programs = {
    bash.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # Modern prompt
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        palette = "noctalia";
        add_newline = false;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
        directory = {
          truncation_length = 3;
          truncate_to_repo = true;
        };
        palettes.noctalia = {
          # Standard colors
          blue = "#6dcbfa";
          red = "#ed8274";
          green = "#facc6e";
          yellow = "#87d96c";
          cyan = "#90e1c6";
          magenta = "#dabafa";
          white = "#c7c7c7";
          black = "#171b24";

          # Extended palette
          rosewater = "#d5ff80";
          flamingo = "#f28779";
          pink = "#dfbfff";
          mauve = "#dabafa";
          maroon = "#f28779";
          peach = "#d5ff80";
          teal = "#90e1c6";
          sky = "#95e6cb";
          sapphire = "#73d0ff";
          lavender = "#dfbfff";

          # Text shades
          text = "#d1d1c7";
          subtext1 = "#c7c7c7";
          subtext0 = "#686868";

          # Surface shades
          overlay2 = "#686868";
          overlay1 = "#686868";
          overlay0 = "#171b24";
          surface2 = "#171b24";
          surface1 = "#171b24";
          surface0 = "#1f2430";
          base = "#1f2430";
          mantle = "#1f2430";
          crust = "#1f2430";
        };
      };
    };

    # Smart directory jumper
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    # Advanced history search with sync
    atuin = {
      enable = true;
      enableZshIntegration = true;
      flags = [
        "--disable-up-arrow"
      ];
      settings = {
        auto_sync = false; # Enable if you want cloud sync
        update_check = false;
        style = "compact";
        inline_height = 20;
        show_preview = true;
      };
    };

    # Fuzzy finder
    fzf = {
      enable = true;
      enableZshIntegration = true;
      # Let atuin handle Ctrl-R for history search
      historyWidget.command = "";
      defaultCommand = "fd --type f --hidden --follow --exclude .git";
      defaultOptions = [
        "--height 40%"
        "--border"
        "--layout=reverse"
      ];
      fileWidget.command = "fd --type f";
      fileWidget.options = [
        "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
      ];
      changeDirWidget.command = "fd --type d";
      changeDirWidget.options = [
        "--preview 'eza --tree --color=always {} | head -200'"
      ];
    };

    # Better cat with syntax highlighting
    bat = {
      enable = true;
      config = {
        theme = "TwoDark";
        style = "numbers,changes,header";
      };
    };

    # Better ls
    eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
      icons = "auto";
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        # eza aliases
        ls = "eza";
        ll = "eza -l";
        la = "eza -la";
        lt = "eza --tree";

        # bat aliases
        cat = "bat";

        # fd aliases
        find = "fd";

        # zoxide aliases
        cd = "z";
      };

      history = {
        size = 10000;
        ignoreAllDups = true;
        path = "$HOME/.zsh_history";
        ignorePatterns = [
          "rm *"
          "pkill *"
          "cp *"
        ];
      };

      # Custom plugins
      plugins = [
        {
          name = "fzf-tab";
          src = pkgs.fetchFromGitHub {
            owner = "Aloxaf";
            repo = "fzf-tab";
            rev = "v1.1.2";
            sha256 = "sha256-Qv8zAiMtrr67CbLRrFjGaPzFZcOiMVEFLg1Z+N6VMhg=";
          };
        }
      ];

      initContent = ''
        # fzf-tab configuration
        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
        zstyle ':fzf-tab:*' switch-group '<' '>'

        # Use fd for fzf when available
        if command -v fd >/dev/null 2>&1; then
          export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
          export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
          export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
        fi

        # Better completion colors
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      '';
    };
  };

  # Install fd (find alternative)
  home.packages = with pkgs; [
    fd
    ripgrep
  ];
}
