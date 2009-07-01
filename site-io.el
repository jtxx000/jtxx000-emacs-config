(require 'io-mode)

(defun io-mode-return ()
  (interactive)
  (if (and (eq last-command 'self-insert-command)
           (string= (buffer-substring (1- (point)) (point)) "{"))
      (progn (newline)
             (newline)
             (insert "}")
             (indent-according-to-mode)
             (forward-line -1))
    (newline-and-indent)))

(defun site-init-io-mode ()
  (c-subword-mode)
  (define-key io-mode-keymap (kbd "<return>") 'io-mode-return))

(add-hook 'io-mode-hook 'site-init-io-mode)
(add-hook 'io-mode-hook 'auto-indent-hook)
