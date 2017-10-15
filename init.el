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
(require 'diminish)
(require 'bind-key)

(scroll-bar-mode -1)
(tool-bar-mode -1)

(setq default-frame-alist
      '((width . 88)
	(height . 71)
	(font . "SF Mono-12")))

(setq make-backup-files nil)

(setq ring-bell-function 'ignore)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'flatui t)

(setq scheme-program-name   "/usr/local/bin/mit-scheme")

(use-package markdown-mode
  :ensure t
  :mode ("\\.md$" . markdown-mode))

(use-package ledger
  :load-path "library/ledger.mode"
  :mode ("\\.ledger$" . ledger-mode))

(use-package geiser
  :ensure t
  :config
  (setq geiser-mit-binary "/usr/local/bin/mit-scheme")
  (setq geiser-racket-binary "/usr/local/bin/racket"))

(use-package slime
  :load-path "library/slime"
  :config
  (require 'slime-autoloads)
  (setq inferior-lisp-program "/usr/local/bin/ccl")
  (add-to-list 'slime-contribs 'slime-fancy))

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (swift-mode geiser magit use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
