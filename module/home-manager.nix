{ inputs, pkgs, ... }:

# manage emacs packages with nix
# port zsh config to nix using pattern in dillon's files
# https://github.com/dmmulroy/kickstart.nix/blob/main/module/home-manager.nix#L136-L160
{
  # add home-manager user settings here
  # generic: zsh,
  # work: awscli, mysql, docker
  imports = [
    ./emacs.nix
  ];

  nixpkgs.config = { allowUnfree = true; };
  # home.packages = with pkgs; [ ack curl ffmpeg ttyd vhs jq tree ];
  home.packages = with pkgs; [
    ack
    aerospace
    awscli2
    curl
    dbeaver-bin
    ffmpeg
    jq
    lazydocker
    nerd-fonts.jetbrains-mono
    pandoc
    ripgrep
    slack
    tree
    ttyd
  ];

  home.stateVersion = "23.11";
  nixpkgs.overlays = [ inputs.emacs-overlay.overlays.default ];

  fonts.fontconfig.enable = true;

  programs = {
    alacritty = {
      enable = true;
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
      aliases = {
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
      extraConfig = {
        init = { defaultBranch = "main"; };
        push = { autoSetupRemote = true; };
        rerere = { enabled = true; };
      };
    };
    neovim = {
      enable = true;
      extraLuaConfig = ''
        vim.opt.nu = true
        vim.opt.rnu = true

        require'nvim-treesitter.configs'.setup {
          auto_install = false,
          highlight = {
            enable = true,
          },
        }
      '';
      plugins = with pkgs.vimPlugins; [
        nvim-treesitter
        nvim-treesitter-parsers.haskell
      ];
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
      # disabling for now as it takes zsh history (aka could leak work stuff)
      autosuggestion.enable = true;
      enableCompletion = true;
      initExtra = "${builtins.readFile ../config/zsh/config.zsh}";
    };
  };
}
