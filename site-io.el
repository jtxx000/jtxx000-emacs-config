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

(definit io
  (auto-indent-hook)
  (c-subword-mode)
  (set-kbd-keys io-mode-keymap ("<return>" . io-mode-return)))
