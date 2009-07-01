(defun site-python-shift (n)
  (save-excursion
    (indent-rigidly (line-beginning-position)
                    (line-end-position)
                    (* n python-indent))))

(defun site-python-shift-left  () (interactive) (site-python-shift -1))
(defun site-python-shift-right () (interactive) (site-python-shift 1))

(definit python
  (auto-indent-hook)
  (set-kbd-keys
    ("<tab>" . site-python-shift-right)
    ("<backtab>" . site-python-shift-left)))
