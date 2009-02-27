(setq inhibit-startup-message t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(setq-default cursor-type 'bar)
(setq-default indent-tabs-mode nil)
(global-font-lock-mode t)
(setq-default truncate-lines t)

(require 'color-theme)
(color-theme-initialize)
(load-library "tango-colour-theme.el")
(color-theme-tango)

(setq show-paren-delay 0)
(show-paren-mode t)

(setq scroll-step 1)
(require 'smooth-scrolling)
