(transient-mark-mode 1)
(setq inhibit-startup-screen t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode 1)
(show-paren-mode 1)
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(noctalia))
 '(custom-safe-themes
   '("e1a0b19f04e6606d118976f58351227cbb29742cf3c0672c685206ad449c4bd3"
	 "9c6aa7eb1bde73ba1142041e628827492bd05678df4d9097cda21b1ebcb8f8b9"
	 "0e8399cd84d1dc3e0e5f5fc6cdd21374bf035bc33d94173d96fbcfa2eefa0642"
	 "9fd51ac6d0704b3a7148d9cb3ce8be07f174bbf432a8e175a4b8eb2ab9d79675"
	 "990b06ea68ce91fb48f038b48f6948682b4ce31379857cfc8a5861fcfcff7297"
	 "c4df9006b9eb32599d758800a32f3487c2cdf13826084511783b47d419024af2"
	 "54a07e4250791390837b3b30289c49b4972cdf350fb12e6430715fc97087caf4"
	 "ab280e79ea968cee506e265bb4c08856ea33d594309bf1d65f0f508a7e3c1b9d"
	 "a68ec832444ed19b83703c829e60222c9cfad7186b7aea5fd794b79be54146e6"
	 "01a9797244146bbae39b18ef37e6f2ca5bebded90d9fe3a2f342a9e863aaa4fd"
	 default))
 '(org-agenda-files '("~/reminder.org"))
 '(package-selected-packages
   '(astyle cape catppuccin-theme company corfu direnv dirvish
			dracula-theme envrc exec-path-from-shell gptel
			gruber-darker-theme helm-fuzzy helm-fuzzy-find
			helm-nixos-options html-to-markdown ido-completing-read+
			ido-hacks lsp-jedi lsp-ui lua-mode magit markdown-mermaid
			minuet move-text multiple-cursors nix-mode orderless
			org-preview-html org-superstar ox-typst rainbow-mode
			tabspaces treemacs-perspective typst-preview typst-ts-mode
			undo-fu vundo web-mode))
 '(safe-local-variable-values nil))
(use-package ox-typst
	:after org)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode +1)
(add-hook 'after-make-frame-functions (lambda (f) (set-face-attribute 'default f :font "NotoMono NF-16")))

(add-to-list 'load-path "~/.config/emacs/autoload/")
(add-to-list 'custom-theme-load-path "~/.config/emacs/themes/")

(require 'simpc-mode)
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))
(fido-vertical-mode 1)
(setq auto-save-default nil)

(require 'move-text)
(global-set-key (kbd "M-p") 'move-text-up)
(global-set-key (kbd "M-n") 'move-text-down)

(setq make-backup-files nil)

(add-hook 'simpc-mode-hook
	(lambda ()
	(interactive)
	(setq-local fill-paragraph-function 'astyle-buffer)))
(require 'multiple-cursors)
(add-hook 'after-init-hook 'rainbow-mode 1)
(add-hook 'prog-mode-hook
	(lambda ()
	(setq indent-tabs-mode t)
	(setq tab-width 4)))
;; Whitespace color corrections.
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(whitespace-missing-newline-at-eof ((t (:foreground "#585b70"))))
 '(whitespace-newline ((t (:foreground "#585b70"))))
 '(whitespace-space ((t (:foreground "#585b70"))))
 '(whitespace-space-after-tab ((t (:foreground "#585b70"))))
 '(whitespace-space-before-tab ((t (:foreground "#585b70"))))
 '(whitespace-tab ((t (:foreground "#585b70"))))
 '(whitespace-trailing ((t (:foreground "#585b70")))))
;; Define the whitespace style.
(setq-default whitespace-style
	'(face empty tabs trailing tab-mark))
(add-hook 'prog-mode-hook 'whitespace-mode 1)
(setq-default whitespace-display-mappings
	'(
	(tab-mark ?\t [124 ?\t] [187 ?\t])))
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(defun format-tab (x)
	"Replace all occurrences of X consecutive spaces with a tab character across the entire buffer."
	(interactive "nNumber of spaces to replace with indent: ")
	(save-excursion
		(save-restriction
			(widen)
			(goto-char (point-min))
			(let ((search-pattern (make-string x ?\s)))
				(while (search-forward search-pattern nil t)
					(replace-match "\t" nil t))))))
(put 'upcase-region 'disabled nil)
(load-theme 'noctalia t)
;; Use Corfu instead of Company

;; 1. Configure Company (Completion UI)
(use-package company
	:ensure t
	:init
	(global-company-mode)
	:config
	(setq company-minimum-prefix-length 1
		company-idle-delay 0.0))

(use-package lsp-mode
	:ensure t
	:init
	(setq lsp-completion-provider :company-mode) ;; Tell lsp-mode not to force company
	:hook
	(
		(python-mode . lsp)
		(c-mode . lsp)
		(nix-mode . lsp)
		(elisp . lsp)
		(html-mode . lsp)
		(css-mode . lsp)
		(js-mode . lsp)
		(typescript-mode . lsp)
		;; If you use web-mode for HTML/JS templates, include it too:
		(web-mode . lsp)
		)
	:commands lsp)
;; 3. Optional UI Enhancements for LSP
(use-package lsp-ui
	:ensure t
	:commands lsp-ui-mode)

(global-set-key (kbd "C-,") 'duplicate-line)
(use-package envrc
	:hook (after-init . envrc-global-mode))

(use-package gptel
	:ensure t
	:config
	(setq gptel-model 'llama3.2:3b
		  gptel-backend (gptel-make-ollama "Ollama"
						  :host "localhost:11434"
						  :stream t
						  :models '(llama3.2:3b)))
	:bind
	(("C-c g g" . gptel)          ; Open a dedicated chat buffer
	 ("C-c g s" . gptel-send)     ; Send prompt / selection to model
	 ("C-c g m" . gptel-menu)))   ; Open the transient settings menu

;; Prefer splitting horizontally (side-by-side)
(setq split-height-threshold nil)
(setq split-width-threshold 80)

(use-package undo-fu
  :ensure t
  :bind
  ("C-z"     . undo-fu-only-undo)
  ("C-S-z"   . undo-fu-only-redo)
  ("M-_"     . undo-fu-only-redo))

(use-package vundo
  :ensure t
  :bind ("C-x u" . vundo)) ; Visual tree navigator when you get lost

(use-package exec-path-from-shell
	:ensure t
	:config
	(exec-path-from-shell-initialize))

(use-package lsp-jedi
	:ensure t
	:after lsp-mode
	:demand t)

(use-package lsp-mode
	:ensure t
	:hook (python-mode . (lambda ()
		(require 'lsp-jedi)
		(lsp-deferred)))
	:init
	(setq lsp-disabled-clients '(pyright pylsp pyls mspyls)))

(setq treesit-language-source-alist
	'((css "https://github.com/tree-sitter/tree-sitter-css")
		(html "https://github.com/tree-sitter/tree-sitter-html")
		(javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
		(nix "https://github.com/nix-community/tree-sitter-nix")
		(python "https://github.com/tree-sitter/tree-sitter-python")))

(org-babel-do-load-languages
	'org-babel-load-languages
	'((emacs-lisp . t)
		(python . t)
		(shell . t)))

;; Disable execution confirmation prompt (use with caution on untrusted files)
(setq org-confirm-babel-evaluate nil)

;; Keep code indentation aligned inside source blocks
(setq org-src-preserve-indentation t)

;; Use native syntax highlighting inside src blocks
(setq org-src-fontify-natively t)

;; Make TAB behave as it would in the language's native major mode
(setq org-src-tab-acts-natively t)

;; Jump instantly with C-x r j <key>
(set-register ?n (cons 'file "~/.config/nixos/"))
(set-register ?s (cons 'file "~/sstudy/"))

;; Enable built-in tab-bar and project.el
(use-package tab-bar
	:init
	(tab-bar-mode 1)
	:custom
	(tab-bar-show 1)
	(tab-bar-close-button-show nil)
	(tab-bar-new-button-show nil))

(use-package tabspaces
	:ensure t
	:hook (after-init . tabspaces-mode)
	:custom
	(tabspaces-use-filtered-buffers-as-default t)
	(tabspaces-default-tab "Default")
	(tabspaces-remove-to-default t)
	(tabspaces-include-buffers '("*scratch*"))
	(tabspaces-session nil)
	(tabspaces-session-auto-restore nil)
	:config
	;; Function to close any tab that isn't a registered Tabspaces workspace
	(defun my/tabspaces-kill-non-workspace-tabs ()
		"Close all open tabs that are not recognized as Tabspaces workspaces."
		(interactive)
		(let ((valid-workspaces (tabspaces--workspace-list)))
			(dolist (tab (tab-bar-tabs))
				(let ((name (alist-get 'name tab)))
					(unless (member name valid-workspaces)
						(tab-bar-close-tab-by-name name))))))

	;; Wrapper to open project workspace and prune non-workspace tabs
	(defun my/tabspaces-open-project-clean ()
		"Open project workspace and close any non-workspace tabs."
		(interactive)
		(call-interactively #'tabspaces-open-or-create-project-and-workspace)
		(my/tabspaces-kill-non-workspace-tabs))

	;; Wrapper to switch workspace and prune non-workspace tabs
	(defun my/tabspaces-switch-workspace-clean ()
		"Switch/create workspace and close any non-workspace tabs."
		(interactive)
		(call-interactively #'tabspaces-switch-or-create-workspace)
		(my/tabspaces-kill-non-workspace-tabs))

	;; Workspace recursive search
	(defun my/workspace-search ()
		"Recursively search file contents inside the active project/workspace."
		(interactive)
		(let ((root (or (when-let ((proj (project-current nil)))
				  (project-root proj))
				default-directory)))
			(if (fboundp 'consult-ripgrep)
				(consult-ripgrep root)
				(project-find-regexp (read-string "Search workspace for: ")))))
	:bind
	(("C-c TAB s" . my/tabspaces-switch-workspace-clean)
	 ("C-c TAB d" . tabspaces-close-workspace)
	 ("C-c TAB p" . my/tabspaces-open-project-clean)
	 ("C-c TAB k" . my/tabspaces-kill-non-workspace-tabs)
	 ("C-c TAB TAB" . tabspaces-switch-buffer-and-tab)
	 ("C-c TAB /" . my/workspace-search)))

(use-package dirvish
	:ensure t
	:init
	(dirvish-override-dired-mode)
	:custom
	;; Global Dired full-view settings
	(dired-listing-switches "-lha --group-directories-first")
	(dirvish-header-line-format nil)
	(dirvish-mode-line-format nil)
	(dirvish-layout-recipes '((0 nil) (1 0.3 0.7)))
	(dirvish-layout-type 0)

	;; Force the sidebar to dock strictly to the LEFT with fixed width
	(dirvish-side-display-alist
		'((side . left)
		  (slot . -1)
		  (window-width . 30)))

	:config
	;; Strip all detail attributes whenever dirvish-side opens
	(add-hook 'dirvish-side-mode-hook
		(lambda ()
			(setq-local dirvish-attributes '(subtree-state))
			(display-line-numbers-mode -1)))

	:bind
	(("C-c f" . dirvish-side)
	 :map dirvish-mode-map
	 ("TAB" . dirvish-subtree-toggle)
	 ("q" . dirvish-quit)
	 ("h" . dired-up-directory)
	 ("l" . dired-find-file)))

(with-eval-after-load 'ox
	(require 'ox-latex))
