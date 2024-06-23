{ pkgs, lib, ... }: {
    programs.emacs = {
      enable = true;
      package =
        (pkgs.emacsWithPackagesFromUsePackage {
        config = ../config/emacs/emacs.el;
	defaultInitFile = true;
	package = pkgs.emacs.override {
          withTreeSitter = true;
          withNativeCompilation = true;
        };
      });
    };
}
