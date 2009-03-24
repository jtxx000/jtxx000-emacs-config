(require 'rst)

(defun site-init-rst ()
  (define-key rst-mode-map (kbd "C-=") 'rst-adjust-decoration)
  (auto-fill-mode)
  (flyspell-mode))

(add-hook 'rst-mode-hook 'site-init-rst)