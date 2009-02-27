(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/vendor")

(load-library "visual")
(load-library "keys")
(load-library "util")
(load-library "misc")
(load-library "show-paren-offscreen")

(load "haskell-mode-2.4/haskell-site-file.el")
(autoload 'cycle-buffer "cycle-buffer" "Cycle forward." t)
(require 'anything-config)
