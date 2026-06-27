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
   '(adwaita-dark-theme almost-mono-themes anti-zenburn-theme
                        app-monochrome-themes astyle base16-theme
                        r-theme-sanityinc-solarized
                        color-theme-sanityinc-tomorrow company
                        company-c-headers constant-theme doom-themes
                        eziam-themes flexoki-themes
                        gruber-darker-theme gruvbox-theme
                        hc-zenburn-theme html-to-markdown
                        iceberg-theme ido-completing-read+ ido-hacks
                        labburn-theme lua-mode magit markdown-mermaid
                        markdown-mode move-text multiple-cursors
                        nix-mode nord-theme nordic-night-theme
                        nordless-theme org-preview-html org-superstar
                        ox-typst rainbow-mode timu-macos-theme
                        tok-theme typst-preview typst-ts-mode))
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
(set-face-attribute 'default nil :font "IosevkaTermSlab NFP-20")

(add-to-list 'load-path "~/.config/emacs/autoload/")
(add-to-list 'custom-theme-load-path "~/.config/emacs/themes/")

(require 'simpc-mode)
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))
;;(ido-mode 1)
;;(ido-everywhere t)
;;
;; (require 'ido)
;; (setq ido-enable-flex-matching t)
;; (setq ido-everywhere t)
;;(ido-mode 1)
;;(ido-ubiquitous-mode 1)
(fido-mode 1)
(setq auto-save-default nil)

(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
(global-set-key (kbd "C-\"")        'mc/skip-to-next-like-this)
(global-set-key (kbd "C-:")         'mc/skip-to-previous-like-this)

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
              '(face spaces empty tabs trailing space-mark tab-mark space-after-tab))
(global-whitespace-mode 1)


;;;; Whitespace color corrections.
;;(require 'color)
;;(let* ((ws-lighten 0) ;; Amount in percentage to lighten up black.
;;       (ws-color (color-lighten-name "#575653" ws-lighten)))
;;  (custom-set-faces
;;   `(whitespace-newline                ((t (:foreground ,ws-color))))
;;   `(whitespace-missing-newline-at-eof ((t (:foreground ,ws-color))))
;;   `(whitespace-space                  ((t (:foreground ,ws-color))))
;;   `(whitespace-space-after-tab        ((t (:foreground ,ws-color))))
;;   `(whitespace-space-before-tab       ((t (:foreground ,ws-color))))
;;   `(whitespace-tab                    ((t (:foreground ,ws-color))))
;;   `(whitespace-trailing               ((t (:foreground ,ws-color))))))

(add-to-list 'write-file-functions 'delete-trailing-whitespace)

(defun untabify-except-makefiles ()
  "Replace tabs with spaces except in makefiles."
  (unless (derived-mode-p 'makefile-mode)
    (untabify (point-min) (point-max))))

(add-hook 'before-save-hook 'untabify-except-makefiles)
(defun on-after-init ()
  (unless (display-graphic-p (selected-frame))
    ;; Set the background of the 'default' face to "unspecified-bg"
    ;; when not in a graphical display (i.e., when in terminal mode)
    (xterm-mouse-mode)
    (set-face-background 'default "unspecified-bg" (selected-frame))))

;; Add this function to the window-setup-hook to run after the frame is set up
(add-hook 'window-setup-hook 'on-after-init)
;; Start in full-screen mode
(add-hook 'window-setup-hook #'toggle-frame-fullscreen t)

;; (add-to-list 'default-frame-alist '(alpha-background . 70))
(add-hook 'org-mode-hook (lambda () (company-mode -1)))
(put 'upcase-region 'disabled nil)
(setq org-src-preserve-indentation t)
(define-globalized-minor-mode my-global-rainbow-mode rainbow-mode (lambda () (rainbow-mode 1)))
(my-global-rainbow-mode 1)


;; (add-to-list 'initial-frame-alist '(fullscreen . maximized))
(set-frame-parameter nil 'alpha-background 100)
(add-to-list 'default-frame-alist '(alpha-background . 100))
(load-theme 'noctalia t)


(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-skip-deadline-if-done t)

(setq org-startup-indented nil)
(add-hook 'markdown-mode-hook (lambda () (whitespace-mode -1)))
