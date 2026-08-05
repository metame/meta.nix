{ inputs, pkgs, ... }:

{
  imports = [
    ./emacs.nix
  ];

  nixpkgs.config = { allowUnfree = true; };
  home.packages = with pkgs; [
    ack
    aerospace
    awscli2
    binutils
    coreutils
    curl
    ffmpeg
    findutils
    gawk
    gettext
    gnupg
    gnugrep
    jq
    yq-go
    lazydocker
    nerd-fonts.jetbrains-mono
    pandoc
    python3
    ripgrep
    tree
    ttyd
    uv
  ];

  home.stateVersion = "23.11";
  nixpkgs.overlays = [ inputs.emacs-overlay.overlays.default ];

  fonts.fontconfig.enable = true;

  programs = {
    alacritty = {
      enable = false;
      settings = {
        font = {
          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Regular";
          };
          bold = {
            family = "JetBrainsMono Nerd Font";
            style = "Bold";
          };
          italic = {
            family = "JetBrainsMono Nerd Font";
            style = "Italic";
          };
          bold_italic = {
            family = "JetBrainsMono Nerd Font";
            style = "Bold Italic";
          };
          size = 24.0;
        };
        window.dimensions = {columns = 88; lines = 31; };
      };
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    git = {
      enable = true;
      settings = {
        init = { defaultBranch = "main"; };
        push = { autoSetupRemote = true; };
        rerere = { enabled = true; };
        alias = {
          co = "checkout";
          ec = "config --global -e";
          ppr = "pull --rebase --prune";
          cob = "checkout -b";
          rb = "branch -m";
          cm = "!git add -A && git commit -m";
          cu = "!git add -u && git commit -m";
          amend = "commit -a --amend";
          save = "!git add -A && git commit -m 'SAVEPOINT'";
          wip = "commit -am 'WIP' --no-verify";
          undo = "reset HEAD~1 --mixed";
          wipe = "!git add -A && git commit -qm 'WIPE SAVEPOINT' && git reset HEAD~1 --hard";
          po = "push origin";
          st = "status";
          unstage = "reset HEAD --";
          ponv = "po --no-verify";
          last = "log -1 HEAD";
	};
      };
    };
    neovim = {
      enable = true;
      initLua = ''
        vim.opt.nu = true
        vim.opt.rnu = true
      '';
      withRuby = false;
      withPython3 = false;
    };
    starship = {
      enable = true;
      settings = {
        aws.disabled = true;
      };
    };
    tmux = {
      enable = true;
      keyMode = "vi";
      mouse = true;
      plugins = with pkgs.tmuxPlugins; [
        resurrect
      ];
    };
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      initContent = "${builtins.readFile ../config/zsh/config.zsh}";
      loginExtra = ''
        eval "$(/opt/homebrew/bin/brew shellenv zsh)"
      '';
    };
  };
}
