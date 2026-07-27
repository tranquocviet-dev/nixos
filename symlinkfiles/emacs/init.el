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
   '("54a07e4250791390837b3b30289c49b4972cdf350fb12e6430715fc97087caf4"
	 "ab280e79ea968cee506e265bb4c08856ea33d594309bf1d65f0f508a7e3c1b9d"
	 "a68ec832444ed19b83703c829e60222c9cfad7186b7aea5fd794b79be54146e6"
	 "01a9797244146bbae39b18ef37e6f2ca5bebded90d9fe3a2f342a9e863aaa4fd"
	 default))
 '(org-agenda-files '("~/reminder.org"))
 '(package-selected-packages
   '(astyle company company-c-headers company-nixos-options company-web
			dash gruber-darker-theme html-to-markdown
			ido-completing-read+ ido-hacks lua-mode magit
			markdown-mermaid markdown-mode move-text multiple-cursors
			nix-mode org-preview-html org-superstar ox-typst
			r-theme-sanityinc-solarized rainbow-mode typst-preview
			typst-ts-mode))
 '(safe-local-variable-values nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(whitespace-missing-newline-at-eof ((t (:foreground "#575756565353"))))
 '(whitespace-newline ((t (:foreground "#575756565353"))))
 '(whitespace-space ((t (:foreground "#575756565353"))))
 '(whitespace-space-after-tab ((t (:foreground "#575756565353"))))
 '(whitespace-space-before-tab ((t (:foreground "#575756565353"))))
 '(whitespace-tab ((t (:foreground "#575756565353"))))
 '(whitespace-trailing ((t (:foreground "#575756565353")))))
(use-package ox-typst
  :after org)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode +1)
(add-hook 'after-make-frame-functions (lambda (f) (set-face-attribute 'default f :font "Maple Mono NF-16")))

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

(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'simpc-mode-hook
	  (lambda ()
		(interactive)
		(setq-local fill-paragraph-function 'astyle-buffer)))
(load-theme 'noctalia t)
(require 'multiple-cursors)
(add-hook 'after-init-hook 'rainbow-mode 1)
