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
		dash gruber-darker-theme highlight-indent-guides
		html-to-markdown ido-completing-read+ ido-hacks lua-mode
		magit markdown-mermaid markdown-mode move-text
		multiple-cursors nix-mode org-preview-html org-superstar
		ox-typst r-theme-sanityinc-solarized rainbow-mode
		typst-preview typst-ts-mode))
 '(safe-local-variable-values
   '((typst-preview--master-file . "/home/viet/notes/2026-03-03_MATH.typ"))))
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
(set-face-attribute 'default nil :font "Maple Mono NF-16")

(add-to-list 'load-path "~/.config/emacs/autoload/")
(add-to-list 'custom-theme-load-path "~/.config/emacs/themes/")

(require 'simpc-mode)
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))
(fido-mode 1)
(setq auto-save-default nil)

(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->")		'mc/mark-next-like-this)
(global-set-key (kbd "C-<")		'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")		'mc/mark-all-like-this)
(global-set-key (kbd "C-\"")		'mc/skip-to-next-like-this)
(global-set-key (kbd "C-:")		'mc/skip-to-previous-like-this)

(require 'move-text)
(global-set-key (kbd "M-p") 'move-text-up)
(global-set-key (kbd "M-n") 'move-text-down)

(defun dupe-line()
  (interactive)
  (duplicate-line)
  (next-line 1)
  )
(global-set-key (kbd "C-,") 'dupe-line)

(defun kill-line()
  (interactive)
  (delete-line)
  )
(global-set-key (kbd "C-.") 'kill-line)

;; (setq-default toggle-truncate-lines 1)
;; (setq-default visual-line-mode 1)
(setq make-backup-files nil)


(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'simpc-mode-hook
	  (lambda ()
		(interactive)
		(setq-local fill-paragraph-function 'astyle-buffer)))

(setq-default whitespace-style
		  '(face spaces empty tabs trailing space-after-tab))
(global-whitespace-mode 1)


;;;; Whitespace color corrections.
;;(require 'color)
;;(let* ((ws-lighten 0) ;; Amount in percentage to lighten up black.
;;	 (ws-color (color-lighten-name "#575653" ws-lighten)))
;;	(custom-set-faces
;;	 `(whitespace-newline		 ((t (:foreground ,ws-color))))
;;	 `(whitespace-missing-newline-at-eof ((t (:foreground ,ws-color))))
;;	 `(whitespace-space			 ((t (:foreground ,ws-color))))
;;	 `(whitespace-space-after-tab	 ((t (:foreground ,ws-color))))
;;	 `(whitespace-space-before-tab	 ((t (:foreground ,ws-color))))
;;	 `(whitespace-tab			 ((t (:foreground ,ws-color))))
;;	 `(whitespace-trailing		 ((t (:foreground ,ws-color))))))

(add-to-list 'write-file-functions 'delete-trailing-whitespace)

(defun untabify-except-makefiles ()
  "Replace tabs with spaces except in makefiles."
  (unless (derived-mode-p 'makefile-mode)
	(untabify (point-min) (point-max))))

(defun tabify-except-makefiles ()
  "Replace tabs with spaces except in makefiles."
  (unless (derived-mode-p 'makefile-mode)
	(tabify (point-min) (point-max))))

;; (add-hook 'before-save-hook 'untabify-except-makefiles)
;; (add-hook 'before-save-hook 'tabify-except-makefiles)

(define-globalized-minor-mode my-global-rainbow-mode rainbow-mode (lambda () (rainbow-mode 1)))
(my-global-rainbow-mode 1)

(load-theme 'noctalia t)

(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
(setq highlight-indent-guides-method 'character)
;; Force Emacs to use real tab characters instead of spaces
(setq-default indent-tabs-mode t)

;; Set the display width of a tab character (e.g., 4 spaces wide)
(setq-default tab-width 4)

;; Optional: Ensure pressing TAB key always inserts a literal tab character
;; instead of trying to auto-indent
(global-set-key (kbd "TAB") 'self-insert-command)
