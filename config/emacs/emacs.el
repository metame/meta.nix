;; considerations for improvements:
;; crux for better "beginning of line" functionality, essentially <0-w>
;; frame title format

(setq debug-on-error t)
(setq comp-async-report-warnings-errors nil)
(setq delete-old-versions -1 ); delete excess backup versions silently
(setq version-control t ); use version control
(setq vc-make-backup-files t ); make backups file even when in version controlled dir
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")) ) ; which directory to put backups file
(setq vc-follow-symlinks t ); don't ask for confirmation when opening symlinked file
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)) ) ;transform backups file name
(setq inhibit-startup-screen t ); inhibit useless and old-school startup screen
(setq coding-system-for-write 'utf-8 )
(setq sentence-end-double-space nil); sentence SHOULD end with only a point.
(setq default-fill-column 80); toggle wrapping text at the 80th character
(setq initial-scratch-message "Welcome in Emacs") ; print a default message in the empty scratch buffer opened at startupa
(scroll-bar-mode 0)
(menu-bar-mode 0)
(tool-bar-mode 0)
(blink-cursor-mode 0)

(set-default 'indent-tabs-mode nil)
(setq css-indent-offset 2)
(setq visible-bell nil)
;; Make sure we always use UTF-8.
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(load-library "iso-transl")

(setq gc-cons-threshold 50000000) ;; allow for more allocated memory before triggering the gc
(setq line-number-display-limit-width 10000)
(setq gnutls-min-prime-bits 4096)
(setq uniquify-buffer-name-style 'forward)
(setq confirm-kill-emacs 'yes-or-no-p)

;; (setq custom-file "~/.emacs.d/etc/custom.el")
;; (load custom-file)			

(when (memq system-type '(darwin windows-nt))
  (setq ring-bell-function 'ignore))

(when (eq system-type 'darwin)
  (setq ns-use-srgb-colorspace nil
        ns-right-alternate-modifier nil))

;; Always ask for y/n keypress instead of typing out 'yes' or 'no'
(defalias 'yes-or-no-p 'y-or-n-p)

;; Automatically save buffers before launching M-x compile and friends,
;; instead of asking you if you want to save.
(setq compilation-ask-about-save nil)

;; Make the selection work like most people expect.
(delete-selection-mode t)
(transient-mark-mode t)

;; Automatically update unmodified buffers whose files have changed.
(global-auto-revert-mode 1)

(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

(setq mouse-yank-at-point t)
(setq save-interprogram-paste-before-kill t)
(setq use-dialog-box nil)

(defun close-all-buffers ()
  (interactive)
  (mapc 'kill-buffer (buffer-list)))

(require 'package)
(setq package-enable-at-startup nil) ; tells emacs not to load any packages before starting up
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
                         ("gnu"       . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")))
(add-to-list 'package-archives
             '("tromey" . "http://tromey.com/elpa/") t)
 (add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)

(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package) ; unless it is already installed
  (package-refresh-contents) ; updage packages archive
  (package-install 'use-package)) ; and install the most recent version of use-package

(require 'use-package)

;; Define the following variables to remove the compile-log warnings
;; when defining ido-ubiquitous
;; (defvar ido-cur-item nil)
;; (defvar ido-default-item nil)
;; (defvar ido-cur-list nil)
;; (defvar predicate nil)
;; (defvar inherit-input-method nil)

;; Sane indentation default
(setq tab-width 2)
(setq js-indent-level 2)

;; parens-handling
;; makes handling lisp expressions much, much easier
;; Cheatsheet: http://www.emacswiki.org/emacs/PareditCheatsheet
(use-package paredit
	     :ensure t)
(use-package rainbow-delimiters
	     :ensure t)

;; edit html tags like sexps
(use-package tagedit
	     :ensure t)

;; evil
(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))
  ;; (progn
  ;;   (setq evil-want-C-u-scroll t)
  ;;   ))

(use-package evil-surround
  :ensure t
  :init
  (progn
    (global-evil-surround-mode 1)
    (evil-define-key 'visual evil-surround-mode-map "s" 'evil-surround-region)
    (evil-define-key 'visual evil-surround-mode-map "S" 'evil-substitute)))

;; escape on quick fd
(use-package evil-escape :ensure t
  :diminish evil-escape-mode
  :config
  (evil-escape-mode))

;; keybindings
(use-package general :ensure t
  :config
  (general-evil-setup)
  (setq general-default-keymaps 'evil-normal-state-map)
  ;; unbind space from dired map to allow for git status
  (general-define-key :keymaps 'dired-mode-map "SPC" nil)
  (general-define-key
   :keymaps 'visual
   "SPC ;"   'comment-or-uncomment-region)
  (general-define-key
   :keymaps 'normal
   "SPC b d" 'kill-this-buffer
   "SPC b b" 'switch-to-buffer
   "SPC f d" 'find-user-init-file
   "SPC f t" 'find-user-todo-file
   "SPC q"   'save-buffers-kill-terminal
   "SPC a d" 'dired
   "SPC TAB" 'switch-to-previous-buffer
   "C-+" 'text-scale-increase
   "C--" 'text-scale-decrease
     "C-=" '(lambda () (interactive) (text-scale-set 1))))


(defun find-user-init-file ()
  "Edit the `user-init-file', in another window."
  (interactive)
  (find-file-other-window user-init-file))

(defconst user-todo-file "~/Dropbox/org/todo.org")

(defun find-user-todo-file ()
  "Edit the `user-todo-file', in another window."
  (interactive)
  (find-file-other-window user-todo-file))

(defun switch-to-previous-buffer ()
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

;; nix
(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'")

;; cider
(use-package cider
  :ensure t
  :init
  (progn
    (setq cider-repl-display-help-banner nil)))

(use-package exec-path-from-shell
  :ensure t
  :config
  (setq exec-path-from-shell-check-startup-files nil)
  (unless (eq system-type 'windows-nt)
      (exec-path-from-shell-initialize)
      (exec-path-from-shell-copy-envs '("PATH"))))

;; Ivy things
(use-package ivy
  :ensure t
  :diminish ivy-mode
  :demand t
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-height 15)
  (setq ivy-count-format "(%d/%d) ")
  :general
  (general-define-key
   :keymaps 'ivy-minibuffer-map
   "C-j" 'ivy-next-line
   "C-k" 'ivy-previous-line))

(use-package counsel :ensure t
  :general
  (general-define-key
   :keymaps 'normal
   "SPC f f" 'counsel-find-file
   "SPC h f" 'counsel-describe-function
   "SPC u"   'counsel-unicode-char
   "SPC p f" 'counsel-git
   "SPC p s" 'counsel-rg
   "SPC SPC" 'counsel-M-x))

(use-package swiper :ensure t
  :general
  (general-define-key
   :keymaps 'normal
   "SPC s" 'swiper))

(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-load-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)

;; which-key
(use-package which-key :ensure t
  :diminish which-key-mode
  :config
  (which-key-mode 1))

(use-package corfu
  :ensure t
  :init (global-corfu-mode)
  :general
  (general-define-key
   :keymaps 'insert
   "C-SPC" 'corfu-complete)
  (general-define-key
   :keymaps 'corfu-map
   "C-j" 'corfu-next
   "C-k" 'corfu-previous))

;; recommended by corfu
(use-package emacs
  :init
  ;; TAB cycle if there are only few candidates
  (setq completion-cycle-threshold 3)
  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (setq tab-always-indent 'complete))

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode)
  :general
  (general-define-key
   :keymaps 'insert
   "C-M-SPC" 'yas-expand))

(use-package diminish
  :ensure t
  :config
  (diminish 'undo-tree-mode))

;; magit
(use-package magit :ensure t
  :general
  (general-define-key
   :keymaps 'normal
   "SPC g s" 'magit-status)
  :config
  (setq magit-completing-read-function 'ivy-completing-read))

(use-package forge :ensure t)

;; Undo all themes
;; (mapcar #'disable-theme custom-enabled-themes)

(use-package doom-themes
  :ensure t
  :preface (defvar region-fg nil)
  :config
  (load-theme 'doom-dracula t))

(use-package powerline
  :ensure t
  :config
  (powerline-center-evil-theme))

(use-package smartparens
  :ensure t
  :diminish smartparens-mode
  :init
  (progn
    (setq sp-message-width nil
          sp-show-pair-from-inside t
          sp-autoescape-string-quote nil
          sp-cancel-autoskip-on-backward-movement nil))
  :config
  (progn
    (sp-local-pair 'minibuffer-inactive-mode "'" nil :actions nil)
    (sp-local-pair 'minibuffer-inactive-mode "`" nil :actions nil)
    (sp-local-pair 'emacs-lisp-mode "'" nil :actions nil)
    (sp-local-pair 'emacs-lisp-mode "`" nil :actions nil)
    (sp-local-pair 'lisp-interaction-mode "'" nil :actions nil)
    (sp-local-pair 'lisp-interaction-mode "`" nil :actions nil)
    (sp-local-pair 'rust-mode "'" nil :actions nil)

    (sp-local-pair 'LaTeX-mode "\"" nil :actions nil)
    (sp-local-pair 'LaTeX-mode "'" nil :actions nil)
    (sp-local-pair 'LaTeX-mode "`" nil :actions nil)
    (sp-local-pair 'latex-mode "\"" nil :actions nil)
    (sp-local-pair 'latex-mode "'" nil :actions nil)
    (sp-local-pair 'latex-mode "`" nil :actions nil)
    (sp-local-pair 'TeX-mode "\"" nil :actions nil)
    (sp-local-pair 'TeX-mode "'" nil :actions nil)
    (sp-local-pair 'TeX-mode "`" nil :actions nil)
    (sp-local-pair 'tex-mode "\"" nil :actions nil)
    (sp-local-pair 'tex-mode "'" nil :actions nil)
    (sp-local-pair 'tex-mode "`" nil :actions nil))
    (smartparens-global-mode)
    (show-smartparens-global-mode))

(use-package neotree
  :ensure t
  :general
  (general-define-key
   :keymaps 'normal
   "SPC f t" 'neotree-toggle))

(use-package restclient :ensure t)

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; tree sitter
(setq treesit-language-source-alist
   '((bash "https://github.com/tree-sitter/tree-sitter-bash")
     (cmake "https://github.com/uyha/tree-sitter-cmake")
     (css "https://github.com/tree-sitter/tree-sitter-css")
     (elisp "https://github.com/Wilfred/tree-sitter-elisp")
     (go "https://github.com/tree-sitter/tree-sitter-go")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
     (json "https://github.com/tree-sitter/tree-sitter-json")
     (make "https://github.com/alemuller/tree-sitter-make")
     (markdown "https://github.com/ikatyang/tree-sitter-markdown")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (rust "https://github.com/tree-sitter/tree-sitter-rust")
     (toml "https://github.com/tree-sitter/tree-sitter-toml")
     (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

 (use-package envrc
   :ensure t
   :init (envrc-global-mode))

;; lsp things

(use-package eglot
  :ensure t
  :hook (((;clojure-mode
           java-mode haskell-mode c-mode c++-mode zig-mode tuareg-mode reason-mode)
          . eglot-ensure))
  ;;       ((cider-mode eglot-managed-mode) . eglot-disable-in-cider))
  ;; :preface
  ;; (defun eglot-disable-in-cider ()
  ;;   (when (eglot-managed-p)
  ;;     (if (bound-and-true-p cider-mode)
  ;;         (progn
  ;;           (remove-hook 'completion-at-point-functions 'eglot-completion-at-point t)
  ;;           (remove-hook 'xref-backend-functions 'eglot-xref-backend t))
  ;;       (add-hook 'completion-at-point-functions 'eglot-completion-at-point nil t)
  ;;       (add-hook 'xref-backend-functions 'eglot-xref-backend nil t))))
  :config
  (setq-default eglot-workspace-configuration
                '((haskell
                   (plugin
                    (stan
                     (globalOn . :json-false))))))
  :custom
  (eglot-autoshutdown t)
  :general
   (general-define-key :keymaps 'eglot-mode-map
                       :states '(normal visual)
                       ", g g" #'xref-find-definitions
                       ", g r" #'xref-find-references
                       ", g b" #'lsp-ui-peek-jump-backward
                       ", g d" #'lsp-ui-doc-glance))

;; helps with eglot going to source for external jar deps
(use-package jarchive
  :ensure t
  :after eglot
  :config
  (jarchive-setup))

;; c lang thing

;; rust things
(use-package rustic
  :ensure t
  :general
  (general-define-key :keymaps 'rust-mode-map
                      :states '(normal visual)
                      ", c f" #'rustic-format-buffer
                      ", c c" #'rustic-cargo-clippy
                      ", c b" #'rustic-cargo-build
                      ", c t" #'rustic-cargo-test
                      ", c r" #'rustic-cargo-run))

(setq rustic-lsp-client 'eglot)

;; (push 'rustic-clippy flycheck-checkers)
;; (remove-hook 'rustic-mode-hook 'flycheck-mode)

;; (use-package cargo
  ;; :ensure t
  ;; :general
  ;; (general-define-key :keymaps 'rust-mode-map
                      ;; :states '(normal visual)
                      ;; ", c b" 'cargo-process-build
                      ;; ", c t" 'cargo-process-test
                      ;; ", c r" 'cargo-process-run))

;; zig
(use-package zig-mode
  :ensure t)

;; guile
(use-package geiser-guile
  :ensure t)

;; common lisp
;; evil-collection needed maybe? to make autocomplete work
(use-package slime
  :ensure t
  :init (setq inferior-lisp-program "sbcl")
  :config
  (slime-setup '(slime-fancy slime-quicklisp slime-asdf)))

;; racket
(use-package racket-mode
  :ensure t)

;; standard ml
(use-package sml-mode
  :ensure t)

;; haskell
(use-package haskell-mode
  :ensure t
  :config
  (setq haskell-interactive-popup-error nil)
  :general
  (general-define-key :keymaps 'haskell-mode-map
                      :states '(normal insert)
                      "C-c C-l" 'haskell-process-load-file))

;; agda
;;(load-file (let ((coding-system-for-read 'utf-8))
   ;;             (shell-command-to-string "agda-mode locate")))

;; ocaml
(use-package tuareg
  :ensure t)

;; reasonml
(use-package reason-mode
  :ensure t)

;; idris
(use-package idris-mode
  :ensure t
  :custom
  (idris-interpreter-path "idris2"))

;; maybe install evil-leader mode to use this
;; (idris-define-evil-keys)

;; purescript
(use-package flycheck
  :ensure t
  :general
  (general-define-key
   :keymaps 'normal
   "SPC e n" 'flycheck-next-error
   "SPC e p" 'flycheck-previous-error))
(use-package purescript-mode
  :ensure t
  :diminish 'purescript-indentation-mode)

(use-package xah-math-input
  :load-path "~/.emacs.d/lisp"
  :general
  (general-define-key
   :keymaps 'insert
   "M-SPC" 'xah-math-input-change-to-symbol))

(defun kc/purescript-hook ()
  "My PureScript mode hook"
  (turn-on-purescript-indentation)
  (psc-ide-mode)
  (flycheck-mode)
  (setq-local flycheck-check-syntax-automatically '(mode-enabled save)))

(use-package psc-ide
  :ensure t
  ;; :load-path "~/code/psc-ide-emacs/"
  :init (add-hook 'purescript-mode-hook 'kc/purescript-hook)
  :config (setq psc-ide-editor-mode t)
  :general
  (general-define-key :keymaps 'purescript-mode-map
                      :states '(normal visual)
                      ", s" 'psc-ide-server-start
                      ", l" 'psc-ide-load-all
                      ", q" 'psc-ide-server-quit
                      ", t" 'psc-ide-show-type
                      ", b" 'psc-ide-rebuild
                      ", g g" 'psc-ide-goto-definition
                      ", a i" 'psc-ide-add-import))

(use-package tex-site
  :ensure auctex
  :mode ("\\.tex\\'" . TeX-latex-mode))

;; whitespace management
(use-package ethan-wspace
  :ensure t
  :diminish 'ethan-wspace-mode
  :init (setq mode-require-final-newline nil
              require-final-newline nil)
  :config (global-ethan-wspace-mode 1))

(use-package yaml-mode
  :ensure t)

;; clojure
(use-package flycheck-clj-kondo
  :ensure t)

(use-package clojure-mode
  :ensure t
  :config
  (require 'flycheck-clj-kondo))

(defun my-clojure-mode-hook ()
    (flycheck-mode)
    (yas-minor-mode 1) ; for adding require/use/import statements
    (cljr-add-keybindings-with-prefix "C-c C-m"))

(add-hook 'clojure-mode-hook #'my-clojure-mode-hook)

(use-package clojure-mode-extra-font-locking
	     :ensure t)


;;
;; These customizations make it easier for you to navigate files,
;; switch buffers, and choose options from the minibuffer.


;; "When several buffers visit identically-named files,
;; Emacs must give the buffers distinct names. The usual method
;; for making buffer names unique adds ‘<2>’, ‘<3>’, etc. to the end
;; of the buffer names (all but one of them).
;; The forward naming method includes part of the file's directory
;; name at the beginning of the buffer name
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Uniquify.html
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; Turn on recent file mode so that you can more easily switch to
;; recently edited files when you first start emacs
(setq recentf-save-file (concat user-emacs-directory ".recentf"))
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 40)

;; allow ido usage in as many contexts as possible.
(use-package ido-completing-read+
	     :ensure t)

;; ido-mode allows you to more easily navigate choices. For example,
;; when you want to switch buffers, ido presents you with a list
;; of buffers in the the mini-buffer. As you start to type a buffer's
;; name, ido will narrow down the list of buffers to match the text
;; you've typed in
;; http://www.emacswiki.org/emacs/InteractivelyDoThings
(ido-mode t)

;; This allows partial matches, e.g. "tl" will match "Tyrion Lannister"
(setq ido-enable-flex-matching t)

;; Turn this behavior off because it's annoying
(setq ido-use-filename-at-point nil)

;; Don't try to match file across all "work" directories; only match files
;; in the current directory displayed in the minibuffer
(setq ido-auto-merge-work-directories-length -1)

;; Includes buffer names of recently open files, even if they're not
;; open now
(setq ido-use-virtual-buffers t)

;; This enables ido in all contexts where it could be useful, not just
;; for selecting buffer and file names
(ido-ubiquitous-mode t)
(ido-everywhere t)

;; Shows a list of buffers
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; Enhances M-x to allow easier execution of commands. Provides
;; a filterable list of possible commands in the minibuffer
;; http://www.emacswiki.org/emacs/Smex
(use-package smex
	     :ensure t)
(setq smex-save-file (concat user-emacs-directory ".smex-items"))
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)

(use-package projectile
	     :ensure t)
;; projectile everywhere!
(projectile-global-mode)

(add-to-list 'default-frame-alist
             '(font . "Andale Mono 14"))

(defun streaming ()
  (interactive)
  (set-face-attribute 'default
                      (selected-frame)
                      :height 200)
  (set-frame-size (selected-frame) 99 42))

(global-set-key (kbd "C-M-s-s") 'streaming)

(setq debug-on-error nil)
(put 'downcase-region 'disabled nil)


;;
;; switch java
;;
(setq JAVA_BASE "/Library/Java/JavaVirtualMachines")

;;
;; This function returns the list of installed
;;
(defun switch-java--versions ()
  "Return the list of installed JDK."
  (seq-remove
   (lambda (a) (or (equal a ".") (equal a "..")))
   (directory-files JAVA_BASE)))


(defun switch-java--save-env ()
  "Store original PATH and JAVA_HOME."
  (when (not (boundp 'SW_JAVA_PATH))
    (setq SW_JAVA_PATH (getenv "PATH")))
  (when (not (boundp 'SW_JAVA_HOME))
    (setq SW_JAVA_HOME (getenv "JAVA_HOME"))))


(defun switch-java ()
  "List the installed JDKs and enable to switch the JDK in use."
  (interactive)
  ;; store original PATH and JAVA_HOME
  (switch-java--save-env)

  (let ((ver (completing-read
              "Which Java: "
              (seq-map-indexed
               (lambda (e i) (list e i)) (switch-java--versions))
              nil t "")))
    ;; switch java version
    (setenv "JAVA_HOME" (concat JAVA_BASE "/" ver "/Contents/Home"))
    (setenv "PATH" (concat (concat (getenv "JAVA_HOME") "/bin/java")
                           ":" SW_JAVA_PATH)))
  ;; show version
  (switch-java-which-version?))


(defun switch-java-default ()
  "Restore the default Java version."
  (interactive)
  ;; store original PATH and JAVA_HOME
  (switch-java--save-env)

  ;; switch java version
  (setenv "JAVA_HOME" SW_JAVA_HOME)
  (setenv "PATH" SW_JAVA_PATH)
  ;; show version
  (switch-java-which-version?))


(defun switch-java-which-version? ()
  "Display the current version selected Java version."
  (interactive)
  ;; displays current java version
  (message (concat "Java HOME: " (getenv "JAVA_HOME"))))
