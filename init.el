(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/vendor")

(load-library "visual")
(load-library "util")
(load-library "keys")
(load-library "misc")
(load-library "show-paren-offscreen")
(load-library "auto-indent")
(load-library "site-c-esque")

(load "haskell-mode-2.4/haskell-site-file.el")
(autoload 'cycle-buffer "cycle-buffer" "Cycle forward." t)
(require 'anything-config)
(load-library "site-yasnippet")

(autoload 'd-mode "d-mode" "Major mode for editing D code." t)
(add-to-list 'auto-mode-alist '("\\.d[i]?\\'" . d-mode))