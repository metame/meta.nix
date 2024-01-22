{ inputs, pkgs, ... }:

{
  # add home-manager user settings here
  # generic: tmux, emacs, git, tree, alacritty, ffmpeg, zsh, jq
  # work: awscli, mysql, docker
  home.packages = with pkgs; [ ];
  home.stateVersion = "23.11";
  nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];

  programs = {
    alacritty = {
      enable = true;
    };
    emacs = {
      enable = true;
      package = pkgs.emacs.override {
        withTreeSitter = true;
        withNativeCompilation = true;
      };
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
        rerere = {enabled = true; };
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
    tmux = {
      enable = true;
      mouse = true;
    };
  };
}
