(defun time-mode-insert-time (&optional time)
  (interactive)
  (insert (format-time-string "%Y-%m-%d %H:%M" (or time (current-time)))))

(defun time-mode-update ()
  (interactive)
  (if (and (is-current-line-whitespace)
           (save-excursion (forward-line -1) (is-current-line-whitespace)))
      (time-mode-insert-time)
    (save-excursion
      (backward-paragraph)
      (if (is-current-line-whitespace)
          (forward-line 1))
      (when (search-forward-regexp "^[^ ]+ [^ ]+\\( - \\)" (line-end-position) t)
        (backward-char 3)
        (delete-region (point) (line-end-position)))
      (end-of-line)
      (insert " - ")
      (time-mode-insert-time))))

(defun time-mode ()
  (interactive)
  (fundamental-mode)
  (local-set-key (kbd "<tab>") 'time-mode-update))

(define-derived-mode time-mode text-mode "Time")

(define-key time-mode-map (kbd "<tab>") 'time-mode-update)
