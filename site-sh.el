(defun make-sh ()
  (interactive)
  (let ((p (= (point) (point-min)))
        deactivate-mark)
    (save-excursion
      (goto-char (point-min))
      (unless (looking-at "#!")
        (insert "#!/bin/bash\n\n")
        (when p
          (setq p (point)))))
    (and p
         (not (equal p t))
         (goto-char p)))
  (sh-mode)
  (setq shebang-file t))

(require 'shebang)
