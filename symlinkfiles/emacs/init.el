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
   '("9fd51ac6d0704b3a7148d9cb3ce8be07f174bbf432a8e175a4b8eb2ab9d79675"
	 "990b06ea68ce91fb48f038b48f6948682b4ce31379857cfc8a5861fcfcff7297"
	 "c4df9006b9eb32599d758800a32f3487c2cdf13826084511783b47d419024af2"
	 "54a07e4250791390837b3b30289c49b4972cdf350fb12e6430715fc97087caf4"
	 "ab280e79ea968cee506e265bb4c08856ea33d594309bf1d65f0f508a7e3c1b9d"
	 "a68ec832444ed19b83703c829e60222c9cfad7186b7aea5fd794b79be54146e6"
	 "01a9797244146bbae39b18ef37e6f2ca5bebded90d9fe3a2f342a9e863aaa4fd"
	 default))
 '(org-agenda-files '("~/reminder.org"))
 '(package-selected-packages
   '(astyle catppuccin-theme company dash gruber-darker-theme helm
			helm-fuzzy helm-fuzzy-find helm-nixos-options
			html-to-markdown ido-completing-read+ ido-hacks lsp-mode
			lsp-ui lua-mode magit markdown-mermaid markdown-mode
			move-text multiple-cursors nix-mode org-preview-html
			org-superstar ox-typst r-theme-sanityinc-solarized
			rainbow-mode typst-preview typst-ts-mode web-mode))
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
(fido-mode 1)
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
