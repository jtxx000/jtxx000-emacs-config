(defun site-python-shift (n)
  (save-excursion
    (indent-rigidly (line-beginning-position)
                    (line-end-position)
                    (* n python-indent))))

(defun site-python-shift-left  () (interactive) (site-python-shift -1))
(defun site-python-shift-right () (interactive) (site-python-shift 1))

(defun site-python-hook ()
  (interactive)
  (local-set-key [tab] 'site-python-shift-right)
  (local-set-key [backtab] 'site-python-shift-left))

(add-hook 'python-mode-hook 'site-python-hook)
(add-hook 'python-mode-hook 'auto-indent-hook)