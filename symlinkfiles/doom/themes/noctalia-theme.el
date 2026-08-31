;;; noctalia-theme.el --- Theme using Template SCSS variables -*- lexical-binding: t -*-

;; Copyright (C) 2025 

;; Author: Generated (Improved)
;; Version: 1.2
;; Package-Requires: ((emacs "24.1"))
;; Keywords: faces

;;; Commentary:

;; A theme using Template SCSS variables with quality of life improvements:
;; - Better source block distinction
;; - Improved text visibility when selected
;; - Refined org-mode styling with hidden asterisks
;; - Enhanced contrast and readability
;; - Seamless integration of source blocks with consistent styling

;;; Code:

(deftheme noctalia "Theme using Template variables with quality of life improvements.")

;; Define all the color variables (replaced by template processor)
(let* ((bg "#fdf5e2")
      (err "#db302d")
      (err-container "#ecc6c5")
      (on-background "#576d74")
      (on-err "#fdf5e2")
      (on-err-container "#410c0b")
      (on-primary "#001419")
      (on-primary-container "#0f3d39")
      (on-secondary "#fdf5e2")
      (on-secondary-container "#410c0b")
      (on-surface "#576d74")
      (on-surface-variant "#576d74")
      (on-tertiary "#001419")
      (on-tertiary-container "#4d3900")
      (outline-color "#879091")
      (outline-variant "#afb5b6")
      (primary "#29a298")
      (primary-container "#a5d8d4")
      (secondary "#db302d")
      (secondary-container "#ecc6c5")
      (shadow "#cac4b5")
      (surface "#fdf5e2")
      (surface-container "#ede7d3")
      (surface-container-high "#e7dfc5")
      (surface-container-highest "#e1d7b6")
      (surface-container-low "#f5eeda")
      (surface-container-lowest "#f9f2df")
      (surface-variant "#ede7d3")
      (tertiary "#b28500")
      (tertiary-container "#f0d175")
      ;; Map success colors to tertiary (as used in other templates)
      (success "#b28500")
      (on-success "#001419")
      (success-container "#f0d175")
      (on-success-container "#4d3900")
      ;; Map fixed colors to regular colors
      (primary-fixed "#29a298")
      (primary-fixed-dim "#a5d8d4")
      (secondary-fixed "#db302d")
      (secondary-fixed-dim "#ecc6c5")
      (tertiary-fixed "#b28500")
      (tertiary-fixed-dim "#f0d175")
      (on-primary-fixed "#001419")
      (on-primary-fixed-variant "#0f3d39")
      (on-secondary-fixed "#fdf5e2")
      (on-secondary-fixed-variant "#410c0b")
      (on-tertiary-fixed "#001419")
      (on-tertiary-fixed-variant "#4d3900")
      ;; Map inverse colors to surface variants
      (inverse-on-surface "#576d74")
      (inverse-primary "#29a298")
      (inverse-surface "#fdf5e2")
      ;; ANSI terminal colors
      (term0 "#cac4b5")
      (term1 "#db302d")
      (term2 "#849900")
      (term3 "#b28500")
      (term4 "#268bd3")
      (term5 "#d23681")
      (term6 "#29a298")
      (term7 "#576d74")
      (term8 "#adb7b7")
      (term9 "#db302d")
      (term10 "#849900")
      (term11 "#b28500")
      (term12 "#268bd3")
      (term13 "#d23681")
      (term14 "#29a298")
      (term15 "#576d74"))

  (custom-theme-set-faces
   'noctalia
   ;; Basic faces
   `(default ((t (:background ,bg :foreground ,on-background))))
   `(cursor ((t (:background ,primary))))
   `(highlight ((t (:background ,surface-container-high))))
   `(region ((t (:background ,primary-container :foreground ,on-primary-container :extend t))))
   `(secondary-selection ((t (:background ,secondary-container :foreground ,on-secondary-container :extend t))))
   `(isearch ((t (:background ,tertiary-container :foreground ,on-tertiary-container :weight bold))))
   `(lazy-highlight ((t (:background ,secondary-container :foreground ,on-secondary-container))))
   `(vertical-border ((t (:foreground ,surface-variant))))
   `(border ((t (:background ,surface-variant :foreground ,surface-variant))))
   `(fringe ((t (:background ,surface :foreground ,outline-variant))))
   `(shadow ((t (:foreground ,outline-variant))))
   `(link ((t (:foreground ,primary :underline t))))
   `(link-visited ((t (:foreground ,tertiary :underline t))))
   `(success ((t (:foreground ,success))))
   `(warning ((t (:foreground ,secondary))))
   `(error ((t (:foreground ,err))))
   `(match ((t (:background ,secondary-container :foreground ,on-secondary-container))))
   
   ;; Font-lock
   `(font-lock-builtin-face ((t (:foreground ,primary))))
   `(font-lock-comment-face ((t (:foreground ,outline-color :slant italic))))
   `(font-lock-comment-delimiter-face ((t (:foreground ,outline-variant))))
   `(font-lock-constant-face ((t (:foreground ,tertiary :weight bold))))
   `(font-lock-doc-face ((t (:foreground ,on-surface-variant :slant italic))))
   `(font-lock-function-name-face ((t (:foreground ,primary :weight bold))))
   `(font-lock-keyword-face ((t (:foreground ,secondary :weight bold))))
   `(font-lock-string-face ((t (:foreground ,tertiary))))
   `(font-lock-type-face ((t (:foreground ,primary-fixed))))
   `(font-lock-variable-name-face ((t (:foreground ,on-surface))))
   `(font-lock-warning-face ((t (:foreground ,err :weight bold))))
   `(font-lock-preprocessor-face ((t (:foreground ,secondary-fixed-dim))))
   `(font-lock-negation-char-face ((t (:foreground ,tertiary-fixed))))

   ;; Show paren
   `(show-paren-match ((t (:background ,primary-container :foreground ,on-primary-container :weight bold))))
   `(show-paren-mismatch ((t (:background ,err-container :foreground ,on-err-container :weight bold))))
   
   ;; Mode line - improved status bar styling
   `(mode-line ((t (:background ,surface-container-high :foreground ,on-surface :box nil))))
   `(mode-line-inactive ((t (:background ,surface :foreground ,on-surface-variant :box nil))))
   `(mode-line-buffer-id ((t (:foreground ,primary :weight bold))))
   `(mode-line-emphasis ((t (:foreground ,primary :weight bold))))
   `(mode-line-highlight ((t (:foreground ,primary :box nil))))
   
   ;; Improved Source blocks - make them integrated with the theme
   `(org-block ((t (:background ,surface-container-low :extend t :inherit fixed-pitch))))
   `(org-block-begin-line ((t (:background ,surface-container-low :foreground ,primary-fixed-dim :extend t :slant italic :inherit fixed-pitch))))
   `(org-block-end-line ((t (:background ,surface-container-low :foreground ,primary-fixed-dim :extend t :slant italic :inherit fixed-pitch))))
   `(org-code ((t (:background ,surface-container-low :foreground ,tertiary-fixed :inherit fixed-pitch))))
   `(org-verbatim ((t (:background ,surface-container-low :foreground ,primary-fixed :inherit fixed-pitch))))
   `(org-meta-line ((t (:foreground ,outline-color :slant italic))))
   
   ;; Org mode with hidden asterisks
   `(org-level-1 ((t (:foreground ,primary :weight bold :height 1.2))))
   `(org-level-2 ((t (:foreground ,secondary :weight bold :height 1.1))))
   `(org-level-3 ((t (:foreground ,tertiary :weight bold))))
   `(org-level-4 ((t (:foreground ,primary :weight bold))))
   `(org-level-5 ((t (:foreground ,secondary :weight bold))))
   `(org-level-6 ((t (:foreground ,tertiary :weight bold))))
   `(org-level-7 ((t (:foreground ,primary :weight bold))))
   `(org-level-8 ((t (:foreground ,secondary :weight bold))))
   `(org-document-title ((t (:foreground ,primary :weight bold :height 1.3))))
   `(org-document-info ((t (:foreground ,primary-container))))
   `(org-todo ((t (:foreground ,err :weight bold))))
   `(org-done ((t (:foreground ,success :weight bold))))
   `(org-headline-done ((t (:foreground ,on-surface-variant))))
   `(org-hide ((t (:foreground ,bg)))) ;; Hide leading asterisks
   `(org-ellipsis ((t (:foreground ,tertiary :underline nil)))) ;; Style for folded content indicator
   `(org-table ((t (:foreground ,secondary-fixed :inherit fixed-pitch))))
   `(org-formula ((t (:foreground ,tertiary :inherit fixed-pitch))))
   `(org-checkbox ((t (:foreground ,primary :weight bold :inherit fixed-pitch))))
   `(org-date ((t (:foreground ,secondary-fixed :underline t))))
   `(org-special-keyword ((t (:foreground ,on-surface-variant :slant italic))))
   `(org-tag ((t (:foreground ,outline-color :weight normal))))
   
   ;; Magit
   `(magit-section-highlight ((t (:background ,surface-container-low))))
   `(magit-diff-hunk-heading ((t (:background ,surface-container :foreground ,on-surface-variant))))
   `(magit-diff-hunk-heading-highlight ((t (:background ,surface-container-high :foreground ,on-surface))))
   `(magit-diff-context ((t (:foreground ,on-surface-variant))))
   `(magit-diff-context-highlight ((t (:background ,surface-container-low :foreground ,on-surface))))
   `(magit-diff-added ((t (:background ,success-container :foreground ,on-success-container))))
   `(magit-diff-added-highlight ((t (:background ,success-container :foreground ,on-success-container :weight bold))))
   `(magit-diff-removed ((t (:background ,err-container :foreground ,on-err-container))))
   `(magit-diff-removed-highlight ((t (:background ,err-container :foreground ,on-err-container :weight bold))))
   `(magit-hash ((t (:foreground ,outline-color))))
   `(magit-branch-local ((t (:foreground ,tertiary :weight bold))))
   `(magit-branch-remote ((t (:foreground ,primary :weight bold))))
   
   ;; Company
   `(company-tooltip ((t (:background ,surface-container :foreground ,on-surface))))
   `(company-tooltip-selection ((t (:background ,primary-container :foreground ,on-primary-container))))
   `(company-tooltip-common ((t (:foreground ,primary))))
   `(company-tooltip-common-selection ((t (:foreground ,on-primary-container :weight bold))))
   `(company-tooltip-annotation ((t (:foreground ,tertiary))))
   `(company-scrollbar-fg ((t (:background ,primary))))
   `(company-scrollbar-bg ((t (:background ,surface-variant))))
   `(company-preview ((t (:foreground ,on-surface-variant :slant italic))))
   `(company-preview-common ((t (:foreground ,primary :slant italic))))
   
   ;; Ido
   `(ido-first-match ((t (:foreground ,primary :weight bold))))
   `(ido-only-match ((t (:foreground ,tertiary :weight bold))))
   `(ido-subdir ((t (:foreground ,secondary))))
   `(ido-indicator ((t (:foreground ,err))))
   `(ido-virtual ((t (:foreground ,outline-color))))
   
   ;; Helm
   `(helm-selection ((t (:background ,primary-container :foreground ,on-primary-container))))
   `(helm-match ((t (:foreground ,primary :weight bold))))
   `(helm-source-header ((t (:background ,surface-container-high :foreground ,primary :weight bold :height 1.1))))
   `(helm-candidate-number ((t (:foreground ,tertiary :weight bold))))
   `(helm-ff-directory ((t (:foreground ,primary :weight bold))))
   `(helm-ff-file ((t (:foreground ,on-surface))))
   `(helm-ff-executable ((t (:foreground ,tertiary))))

   ;; corfu
   `(corfu-default ((t (:background ,surface-container :foreground ,on-surface))))
   `(corfu-current ((t (:background ,primary-container :foreground ,on-primary-container))))
   
   ;; Which-key
   `(which-key-key-face ((t (:foreground ,primary :weight bold))))
   `(which-key-separator-face ((t (:foreground ,outline-variant))))
   `(which-key-command-description-face ((t (:foreground ,on-surface))))
   `(which-key-group-description-face ((t (:foreground ,secondary))))
   `(which-key-special-key-face ((t (:foreground ,tertiary :weight bold))))
   
   ;; Line numbers
   `(line-number ((t (:foreground ,outline-variant :inherit fixed-pitch))))
   `(line-number-current-line ((t (:foreground ,primary :weight bold :inherit fixed-pitch))))
   
   ;; Parenthesis matching
   `(sp-show-pair-match-face ((t (:background ,primary-container :foreground ,on-primary-container))))
   `(sp-show-pair-mismatch-face ((t (:background ,err-container :foreground ,on-err-container))))
   
   ;; Rainbow delimiters
   `(rainbow-delimiters-depth-1-face ((t (:foreground ,primary))))
   `(rainbow-delimiters-depth-2-face ((t (:foreground ,secondary))))
   `(rainbow-delimiters-depth-3-face ((t (:foreground ,tertiary))))
   `(rainbow-delimiters-depth-4-face ((t (:foreground ,primary-fixed))))
   `(rainbow-delimiters-depth-5-face ((t (:foreground ,secondary-fixed))))
   `(rainbow-delimiters-depth-6-face ((t (:foreground ,tertiary-fixed))))
   `(rainbow-delimiters-depth-7-face ((t (:foreground ,primary-fixed-dim))))
   `(rainbow-delimiters-depth-8-face ((t (:foreground ,secondary-fixed-dim))))
   `(rainbow-delimiters-depth-9-face ((t (:foreground ,tertiary-fixed-dim))))
   `(rainbow-delimiters-mismatched-face ((t (:foreground ,err :weight bold))))
   `(rainbow-delimiters-unmatched-face ((t (:foreground ,err :weight bold))))
   
   ;; Dired
   `(dired-directory ((t (:foreground ,primary :weight bold))))
   `(dired-ignored ((t (:foreground ,outline-variant))))
   `(dired-flagged ((t (:foreground ,err))))
   `(dired-marked ((t (:foreground ,tertiary :weight bold))))
   `(dired-symlink ((t (:foreground ,secondary :slant italic))))
   `(dired-header ((t (:foreground ,primary :weight bold :height 1.1))))
   
   ;; Terminal colors
   `(term-color-black ((t (:foreground ,term0 :background ,term0))))
   `(term-color-red ((t (:foreground ,term1 :background ,term1))))
   `(term-color-green ((t (:foreground ,term2 :background ,term2))))
   `(term-color-yellow ((t (:foreground ,term3 :background ,term3))))
   `(term-color-blue ((t (:foreground ,term4 :background ,term4))))
   `(term-color-magenta ((t (:foreground ,term5 :background ,term5))))
   `(term-color-cyan ((t (:foreground ,term6 :background ,term6))))
   `(term-color-white ((t (:foreground ,term7 :background ,term7))))
   
   ;; EShell
   `(eshell-prompt ((t (:foreground ,primary :weight bold))))
   `(eshell-ls-directory ((t (:foreground ,primary :weight bold))))
   `(eshell-ls-symlink ((t (:foreground ,secondary :slant italic))))
   `(eshell-ls-executable ((t (:foreground ,tertiary))))
   `(eshell-ls-archive ((t (:foreground ,on-tertiary-container))))
   `(eshell-ls-backup ((t (:foreground ,outline-variant))))
   `(eshell-ls-clutter ((t (:foreground ,err))))
   `(eshell-ls-missing ((t (:foreground ,err))))
   `(eshell-ls-product ((t (:foreground ,on-surface-variant))))
   `(eshell-ls-readonly ((t (:foreground ,on-surface-variant))))
   `(eshell-ls-special ((t (:foreground ,secondary-fixed))))
   `(eshell-ls-unreadable ((t (:foreground ,outline-variant))))
   
   ;; Improved markdown mode
   `(markdown-header-face ((t (:foreground ,primary :weight bold))))
   `(markdown-header-face-1 ((t (:foreground ,primary :weight bold :height 1.2))))
   `(markdown-header-face-2 ((t (:foreground ,primary-container :weight bold :height 1.1))))
   `(markdown-header-face-3 ((t (:foreground ,secondary :weight bold))))
   `(markdown-header-face-4 ((t (:foreground ,secondary-container :weight bold))))
   `(markdown-inline-code-face ((t (:foreground ,tertiary-fixed :background ,surface-container-low :inherit fixed-pitch))))
   `(markdown-code-face ((t (:background ,surface-container-low :extend t :inherit fixed-pitch))))
   `(markdown-pre-face ((t (:background ,surface-container-low :inherit fixed-pitch))))
   `(markdown-table-face ((t (:foreground ,secondary-fixed :inherit fixed-pitch))))
   
   ;; Web mode
   `(web-mode-html-tag-face ((t (:foreground ,primary))))
   `(web-mode-html-tag-bracket-face ((t (:foreground ,on-surface-variant))))
   `(web-mode-html-attr-name-face ((t (:foreground ,secondary))))
   `(web-mode-html-attr-value-face ((t (:foreground ,tertiary))))
   `(web-mode-css-selector-face ((t (:foreground ,primary))))
   `(web-mode-css-property-name-face ((t (:foreground ,secondary))))
   `(web-mode-css-string-face ((t (:foreground ,tertiary))))
   
   ;; Flycheck
   `(flycheck-error ((t (:underline (:style wave :color ,err)))))
   `(flycheck-warning ((t (:underline (:style wave :color ,secondary)))))
   `(flycheck-info ((t (:underline (:style wave :color ,tertiary)))))
   `(flycheck-fringe-error ((t (:foreground ,err))))
   `(flycheck-fringe-warning ((t (:foreground ,secondary))))
   `(flycheck-fringe-info ((t (:foreground ,tertiary))))
   
   ;; Mini-buffer customization
   `(minibuffer-prompt ((t (:foreground ,primary :weight bold))))
   
   ;; Improved search highlighting
   `(lsp-face-highlight-textual ((t (:background ,primary-container :foreground ,on-primary-container :weight bold))))
   `(lsp-face-highlight-read ((t (:background ,secondary-container :foreground ,on-secondary-container :weight bold))))
   `(lsp-face-highlight-write ((t (:background ,tertiary-container :foreground ,on-tertiary-container :weight bold))))
   
   ;; Info and help modes
   `(info-title-1 ((t (:foreground ,primary :weight bold :height 1.3))))
   `(info-title-2 ((t (:foreground ,primary-container :weight bold :height 1.2))))
   `(info-title-3 ((t (:foreground ,secondary :weight bold :height 1.1))))
   `(info-title-4 ((t (:foreground ,secondary-container :weight bold))))
   `(Info-quoted ((t (:foreground ,tertiary))))
   `(info-menu-header ((t (:foreground ,primary :weight bold))))
   `(info-menu-star ((t (:foreground ,primary))))
   `(info-node ((t (:foreground ,tertiary :weight bold))))

   ;; Tabs
   `(tab-bar ((t (:background ,surface-container-high :foreground ,on-surface :box nil))))
   `(tab-bar-tab ((t (:background ,surface-container-high :foreground ,on-surface :weight bold :box nil))))
   `(tab-bar-tab-inactive ((t (:background ,surface :foreground ,on-surface-variant :box nil))))

   `(tab-line ((t (:background ,surface-container-high :foreground ,on-surface :box nil))))
   `(tab-line-tab ((t (:background ,surface :foreground ,on-surface-variant :box nil))))
   `(tab-line-tab-current ((t (:background ,surface-container-high :foreground ,on-surface :weight bold :box nil))))
   `(tab-line-tab-inactive ((t (:background ,surface :foreground ,on-surface-variant :box nil))))
   `(tab-line-highlight ((t (:background ,surface-container-highest :foreground ,on-surface))))

   `(centaur-tabs-default ((t (:background ,surface-container-high :foreground ,on-surface))))
   `(centaur-tabs-selected ((t (:background ,surface-container-high :foreground ,on-surface :weight bold))))
   `(centaur-tabs-unselected ((t (:background ,surface :foreground ,on-surface-variant))))
   `(centaur-tabs-selected-modified ((t (:background ,surface-container-high :foreground ,tertiary :weight bold))))
   `(centaur-tabs-unselected-modified ((t (:background ,surface :foreground ,tertiary))))
   `(centaur-tabs-active-bar-face ((t (:background ,primary))))
   
   ;; Fixed-pitch faces
   `(fixed-pitch ((t (:family "monospace"))))
   `(fixed-pitch-serif ((t (:family "monospace serif"))))
   
   ;; Variable-pitch face
   `(variable-pitch ((t (:family "sans serif"))))
   ))

;; Add org-mode hooks for hiding leading stars
(with-eval-after-load 'org
  (setq org-hide-leading-stars t)
  (setq org-startup-indented t))

;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'noctalia)
;;; noctalia-theme.el ends here
