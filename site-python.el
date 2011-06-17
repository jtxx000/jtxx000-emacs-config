;; (defun site-python-shift (n)
;;   (save-excursion
;;     (indent-rigidly (line-beginning-position)
;;                     (line-end-position)
;;                     (* n python-indent))))

;; (defun site-python-shift-left  () (interactive) (site-python-shift -1))
;; (defun site-python-shift-right () (interactive) (site-python-shift 1))

(definit python
  (set-kbd-keys
    ("<tab>" . python-shift-right)
    ("<backtab>" . python-shift-left))
  (set-kbd-keys
    ("<backspace>" . python-backspace))
  (preserve-key-bindings "<backspace>")
  (auto-indent-mode))
