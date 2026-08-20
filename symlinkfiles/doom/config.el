;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "NotoMono NF" :size 18 :weight 'regular))
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-tomorrow-night)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(after! (flycheck org)
	(setq-default flycheck-disabled-checkers
		(delq 'org-lint flycheck-disabled-checkers)))
(after! eglot
  (add-to-list 'eglot-server-programs
	       '((nix-mode nix-ts-mode) . ("nixd")))

  (setq-default eglot-workspace-configuration
		'((:nixd .
		   (:nixpkgs (:expr "import <nixpkgs> { }")
		    :options
		    (:nixos (:expr "(builtins.getFlake \"/home/dice/.config/nixos\").nixosConfigurations.nixos.options")))))))

(add-hook! '(nix-mode-hook nix-ts-mode-hook) #'eglot-ensure)
;; Enable tabs globally for all programming modes
(setq-default indent-tabs-mode t)
(setq-default tab-width 4)

;; Prevent Doom's electric-indent from converting tabs to spaces
(setq-default evil-shift-round nil)
(setq-default evil-shift-width tab-width)

;; Ensure major modes respect tab-width
(add-hook! 'prog-mode-hook
	(setq indent-tabs-mode t
		tab-width 4))
;; Stop whitespace-mode from showing tabs as '>'
(after! whitespace
	(setq whitespace-style '(face trailing-whitespace)))

;; Configure VS Code-like vertical bars
(after! highlight-indent-guides
	(setq highlight-indent-guides-method 'character
		highlight-indent-guides-character ?│
		highlight-indent-guides-responsive 'top))
(after! org
	(setq org-agenda-files '("~/org")))
(after! org-capture
	(defun +zettelkasten-slugify (str)
		"Format a title string for filenames."
		(replace-regexp-in-string "[/\\:*?\"<>|]" "-" str))

	(setq org-capture-templates
		'(("r" "Reminder / Task" entry
				(file+headline "~/org/reminder.org" "Reminders")
				"* TODO %?\nSCHEDULED: %^t\n:PROPERTIES:\n:CREATED: %U\n:END:\n"
				:empty-lines 1)

			("z" "Zettelkasten")

			;; Fleeting Note: Auto-named with timestamp, no prompt
			("zf" "Fleeting Note" plain
				(file (lambda ()
					(let ((filename (format-time-string "%d-%m-%Y %H-%M-%S.org")))
						(expand-file-name filename "~/org/zettelkasten/fleeting"))))
				"#+title: Fleeting Note %<%d-%m-%Y %H:%M:%S>\n#+date: %U\n#+filetags: :fleeting:\n\n%?"
				:empty-lines 1)

			;; Literature Note: Summaries/notes from books, papers, articles
			("zl" "Literature Note" plain
				(file (lambda ()
					(let ((date (format-time-string "%d-%m-%Y"))
							(title (read-string "Note name: ")))
						(expand-file-name
							(format "%s %s.org" date (+zettelkasten-slugify title))
							"~/org/zettelkasten/literature"))))
				"#+title: %^{Title}\n#+date: %U\n#+filetags: :literature:\n#+author: %^{Author}\n#+source: %^{Source/URL}\n\n* Key Takeaways\n- %?\n\n* Summary\n\n* Quotes / References\n"
				:empty-lines 1)

			;; Permanent Note: Atomic, refined, self-contained knowledge
			("zp" "Permanent Note" plain
				(file (lambda ()
					(let ((date (format-time-string "%d-%m-%Y"))
							(title (read-string "Note name: ")))
						(expand-file-name
							(format "%s %s.org" date (+zettelkasten-slugify title))
							"~/org/zettelkasten/permanent"))))
				"#+title: %^{Title}\n#+date: %U\n#+filetags: :permanent:\n\n* Concept\n%?\n\n* Related Notes\n- \n\n* References\n- "
				:empty-lines 1))))

(after! apheleia
  ;; Nix: nixfmt converted to hard tabs (2-space base)
  (set-formatter! 'nixfmt-tabs
    '("sh" "-c" "nixfmt | unexpand -t 2 --first-only")
    :modes '(nix-mode nix-ts-mode))

  ;; Python: ruff formatted then converted to hard tabs (4-space base)
  (set-formatter! 'ruff-tabs
    '("sh" "-c" "ruff format - | unexpand -t 4 --first-only")
    :modes '(python-mode python-ts-mode)))
(setq org-startup-with-inline-images t
      org-image-actual-width '(600)) ; Resize display width
