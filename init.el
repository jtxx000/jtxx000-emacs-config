(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/vendor")

(server-start)

(load-library "visual")
(load-library "util")
(load-library "misc")
(load-library "show-paren-offscreen")
(require 'auto-indent)
(load-library "site-c-esque")
(load-library "time-mode")
(load-library "notes-mode")

(load "haskell-mode-2.4/haskell-site-file.el")
;(autoload 'cycle-buffer "cycle-buffer" "Cycle forward." t)
;(require 'anything-config)
;(load "auctex.el" nil t t)
;(load "preview-latex.el" nil t t)
(load-library "site-yasnippet")
(load-library "site-rst")
(load-library "site-io")
(load-library "site-python")
(load-library "site-cpp")
(load-library "site-lisp")
(load-library "site-compilation")
(load-library "site-org")
(load-library "site-auto-indent")
(require 'haml-mode)
(require 'sass-mode)
(require 'paredit)
(require 'no-word)
(add-to-list 'auto-mode-alist '("\\.doc\\'" . no-word))
(require 'cycle-buffer)
(require 'smex)
(smex-initialize)
(load-library "keys")
(load-library "site-calendar")
(require 'geiser-install nil t)
(load-library "site-geiser")
(load-library "site-mail")
(load-library "site-dired")
(load-library "site-sh")

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

(require 'elisp-format)
(require 'w3m-load)
;(setq browse-url-browser-function 'w3m-browse-url)
(require 'processing-mode)
(add-to-list 'auto-mode-alist '("\\.pde$" . processing-mode))
(setq processing-location "/usr/share/processing/")

(autoload 'php-mode "php-mode.el" "Php mode." t)
(setq auto-mode-alist (append '(("/*.\.php[345]?$" . php-mode)) auto-mode-alist))

(autoload 'd-mode "d-mode" "Major mode for editing D code." t)

;(autoload 'magit-status "magit" nil t)

(require 'magit)
(require 'filladapt)

(load-library "site-maxima")
(load-library "site-js")

;(add-to-list 'load-path "/usr/share/emacs/site-lisp/auto-complete")
;(require 'auto-complete-config)
;(add-to-list 'ac-dictionary-directories "/usr/share/emacs/site-lisp/auto-complete/ac-dict")
;(ac-config-default)

(add-to-list 'auto-mode-alist '("\\.d[i]?\\'" . d-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(add-to-list 'auto-mode-alist '("\\.lzz\\'" . c++-mode))
(eval-after-load 'flymake
  '(add-to-list 'flymake-allowed-file-name-masks '("\\.lzz\\'" flymake-simple-make-init)))

(add-to-list 'auto-mode-alist '("\\.rb\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\work-hours\\'" . time-mode))
(add-to-list 'interpreter-mode-alist '("python2" . python-mode))

(require 'sws-mode)
(require 'jade-mode)
(add-to-list 'auto-mode-alist '("\\.styl$" . sws-mode))
(add-to-list 'auto-mode-alist '("\\.jade$" . jade-mode))

(setq auto-mode-alist (append '() auto-mode-alist))
(put 'erase-buffer 'disabled nil)

(semantic-mode)
(global-semantic-idle-completions-mode)
;(global-semantic-idle-local-symbol-highlight-mode)
;(global-semantic-idle-summary-mode)

(require 'autopair)
(autopair-global-mode)

(require 'flymake-cursor)
(require 'rfringe)

(eval-after-load "speedbar" '(speedbar-add-supported-extension ".lzz"))
(setq auto-save-hook (delete 'semanticdb-save-all-db-idle auto-save-hook))
