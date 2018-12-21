;; init.el
;; strongly inspired by Casey Muratori's .emacs file used in his "Handmade Hero" series

;; check OS type
(cond
 ((string-equal system-type "windows-nt") ; Microsoft Windows
  (progn
    (setq arh-env-win32 t
	  arh-env-osx nil
	  arh-env-linux nil)))
 ((string-equal system-type "darwin") ; Mac OS X
  (progn
    (setq arh-env-osx t
	  arh-env-win32 nil
	  arh-env-linux nil)))
 ((string-equal system-type "gnu/linux") ; linux
  (progn
    (setq arh-env-linux t
	  arh-env-win32 nil
	  arh-env-osx nil))))

(global-hl-line-mode 1)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(ido-mode t)
(setq inhibit-splash-screen t)
(set-variable 'grep-command "grep -irHn ")
(setq make-backup-files nil)
(setq ring-bell-function 'ignore)
(setq c-default-style "bsd"
      c-basic-offset 2)
(setq scroll-step 3)
(setq next-screen-context-lines 3)

(if arh-env-osx
    (progn
      (cua-mode 0)
      (setq mac-command-modifier 'meta)
;;      (setq arh-font "SF Mono-12")))
      (setq arh-font "InputMono-12")))

(if arh-env-win32
    (progn
      (setq arh-font "Liberation Mono-09")
      (setq-default indent-tabs-mode nil)))

(if arh-env-linux
    (progn
      (setq arh-font "Liberation Mono-13")))

(setq default-frame-alist
      '((width . 88)
	(height . 71)
	(ns-transparent-titlebar . t)
	(ns-appearance . dark)))

(add-to-list 'default-frame-alist (cons 'font arh-font))

;; Set up comment tags
(setq fixme-modes '(c++-mode
		    c-mode
		    emacs-lisp-mode
		    ruby-mode
		    lisp-mode
		    scheme-mode
		    swift-mode
		    go-mode
		    js-mode))

(make-face 'font-lock-fixme-face)
(make-face 'font-lock-study-face)
(make-face 'font-lock-important-face)
(make-face 'font-lock-note-face)

(set-face-attribute 'font-lock-fixme-face nil
		    :foreground "Red"
		    :slant 'italic)
(set-face-attribute 'font-lock-study-face nil
		    :foreground "Blue"
		    :slant 'italic)
(set-face-attribute 'font-lock-important-face nil
		    :foreground "Black"
		    :background "Yellow"
		    :weight 'bold
		    :slant 'italic)
(set-face-attribute 'font-lock-note-face nil
		    :foreground "Dark Green"
		    :slant 'italic)

(mapc (lambda (mode)
	(font-lock-add-keywords
	 mode
	 '(("\\<\\(TODO\\)" 1 'font-lock-fixme-face t)
	   ("\\<\\(STUDY\\)" 1 'font-lock-study-face t)
	   ("\\<\\(IMPORTANT\\)" 1 'font-lock-important-face t)
           ("\\<\\(NOTE\\)" 1 'font-lock-note-face t))))
      fixme-modes)

;; TAB completes, SHIFT-TAB actually add a tab
(setq dabbrev-case-replace t)
(setq dabbrev-case-fold-search t)
(setq dabbrev-upcase-means-case-search t)

(global-set-key "\t" 'dabbrev-expand)
(global-set-key [S-tab] 'indent-for-tab-command)
(global-set-key [backtab] 'indent-for-tab-command)
;; (setq tab-always-indent 'complete)
;; (add-to-list 'completion-styles 'initials t)

(defun switch-to-*scratch* ()
  (interactive)
  (switch-to-buffer "*scratch*"))

(global-set-key (kbd "<f5>") 'switch-to-*scratch*)

(defun arh-replace-string (FromString ToString)
  "Replace a string without moving point."
  (interactive "sReplace: \nsReplace: %s  With: ")
  (save-excursion
    (beginning-of-buffer)
    (replace-string FromString ToString)))
(global-set-key (kbd "C-x C-r") 'arh-replace-string)

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
 (require 'use-package))
(require 'bind-key)

(setq scheme-program-name   "/usr/local/bin/mit-scheme")

(use-package markdown-mode
  :ensure t
  :mode ("\\.md$" . markdown-mode))

(use-package ledger-mode
  :load-path "library/ledger-mode"
  :mode ("\\.ledger$" . ledger-mode))

(when arh-env-osx
  (use-package geiser
    :ensure t
    :config
    (setq geiser-mit-binary "/usr/local/bin/mit-scheme")
    (setq geiser-racket-binary "/usr/local/bin/racket")))

(use-package slime
  :ensure t
  :config
  (require 'slime-autoloads)
  (setq inferior-lisp-program "/usr/local/bin/sbcl")
  (add-to-list 'slime-contribs 'slime-fancy))

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

(require 'mmm-auto)
(setq mmm-global-mode 'auto)

(mmm-add-mode-ext-class 'html-erb-mode "\\.html\\.erb\\'" 'erb)
(mmm-add-mode-ext-class 'html-erb-mode nil 'html-js)
(mmm-add-mode-ext-class 'html-erb-mode nil 'html-css)

(add-to-list 'auto-mode-alist '("\\.html\\.erb\\'" . html-erb-mode))

(setq mmm-submode-decoration-level 0
      mmm-parse-when-idle t)

(mmm-add-group
 'fancy-html
 '((html-erb
    :submode ruby-mode
    :match-face (("<%#" . mmm-comment-submode-face)
		 ("<%=" . mmm-output-submode-face)
		 ("<%"  . mmm-code-submode-face))
    :front "<%[#=]?"
    :back "%>"
    :insert ((?% erb-code       nil @ "<%"  @ " " _ " " @ "%>" @)
	     (?# erb-comment    nil @ "<%#" @ " " _ " " @ "%>" @)
	     (?= erb-expression nil @ "<%=" @ " " _ " " @ "%>" @)))))

(add-to-list 'mmm-mode-ext-classes-alist '(html-mode nil fancy-html))

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(add-to-list 'load-path "~/.emacs.d/themes")
(load-theme 'gruvbox-dark-medium t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("896e853cbacc010573cd82b6cf582a45c46abe2e45a2f17b74b4349ff7b29e34" "98cc377af705c0f2133bb6d340bf0becd08944a588804ee655809da5d8140de6" "7f89ec3c988c398b88f7304a75ed225eaac64efa8df3638c815acc563dfd3b55" "a622aaf6377fe1cd14e4298497b7b2cae2efc9e0ce362dade3a58c16c89e089c" "2a9039b093df61e4517302f40ebaf2d3e95215cb2f9684c8c1a446659ee226b9" "5dc0ae2d193460de979a463b907b4b2c6d2c9c4657b2e9e66b8898d2592e3de5" "3898b4f9c3f6f2994f5010f766a7f7dac4ee2a5c5eb18c429ab8e71c5dad6947" "725a0ac226fc6a7372074c8924c18394448bb011916c05a87518ad4563738668" "e2fd81495089dc09d14a88f29dfdff7645f213e2c03650ac2dd275de52a513de" "be73fbde027b9df15a98a044bcfff4d46906b653cb6eef0d98ebccb7f8425dc9" default)))
 '(package-selected-packages
   (quote
    (gotham-theme pug-mode go-mode slime mmm-mode swift-mode geiser magit use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
