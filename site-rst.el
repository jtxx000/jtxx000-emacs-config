(require 'rst)

(defun site-init-rst ()
  (define-key rst-mode-map (kbd "C-=") 'rst-adjust-decoration)
  (auto-fill-mode)
  (setq paragraph-start "\\f\\|[ \\t]*$")
  (setq paragraph-separate "[ \\t\\f]*$")
  (flyspell-mode))

(add-hook 'rst-mode-hook 'site-init-rst)