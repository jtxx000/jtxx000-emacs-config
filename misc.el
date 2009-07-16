(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)
(setq auto-save-list-file-prefix "~/.emacs-meta/auto-save-list/.saves-")
(setq backup-directory-alist '(("." . "~/.emacs-meta/")))

(put 'narrow-to-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
(winner-mode)
(iswitchb-mode t)
