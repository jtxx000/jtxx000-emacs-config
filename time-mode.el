(defun time-mode-insert-time (&optional time)
  (interactive)
  (insert (format-time-string "%Y-%m-%d %H:%M" (or time (current-time)))))

(defun time-mode-update ()
  (interactive)
  (let ((last-time (buffer-substring (save-excursion
                                       (forward-line -1)
                                       (line-beginning-position))
                                     (line-beginning-position))))
    (if (string-match "\\`[\n\t ]*\\'" last-time)
        (time-mode-insert-time)
      (loop with last = (parse-time last-time)
            with cur = (current-time)
            for x from 1
            for y = (seconds-to-time
                     (+ (* 60 6 x)
                        (time-to-seconds last)))
            while (time-less-p y cur)
            do (progn
                 (if (/= x 1) (newline))
                 (time-mode-insert-time y))))))

(defun time-mode ()
  (interactive)
  (fundamental-mode)
  (local-set-key (kbd "<tab>") 'insert-time))

(define-derived-mode time-mode text-mode "Time")

(define-key time-mode-map (kbd "<tab>") 'time-mode-update)
