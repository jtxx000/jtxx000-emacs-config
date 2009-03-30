(defun time-mode-insert-time (&optional time)
  (interactive)
  (insert (format-time-string "%Y-%m-%d %H:%M" (or time (current-time)))))

(defun time-mode-get-increment (last x)
  (seconds-to-time
   (+ (* 60 6 x)
      (time-to-seconds last))))

(defun time-mode-update ()
  (interactive)
  (unless (is-current-line-whitespace)
    (forward-paragraph)
    (unless (is-current-line-whitespace)
      (end-of-line)
      (newline)))
  (let ((last-time (buffer-substring (save-excursion
                                       (forward-line -1)
                                       (line-beginning-position))
                                     (line-beginning-position))))
    (if (is-horizontal-whitespace last-time)
        (progn (insert "*")
               (time-mode-insert-time))
      (let ((last (parse-time last-time))
            (cur (current-time)))
        (if (and (string= (substring last-time 0 1) "*")
                 (time-less-p (time-mode-get-increment last 1) cur))
            (save-excursion (forward-line -1)
                            (line-beginning-position)
                            (delete-char 1)))
        (loop for x from 1
              while (time-less-p (time-mode-get-increment last (1+ x)) cur)
              do (progn
                   (if (/= x 1) (newline))
                   (time-mode-insert-time (time-mode-get-increment last x))))))))

(defun time-mode ()
  (interactive)
  (fundamental-mode)
  (local-set-key (kbd "<tab>") 'insert-time))

(define-derived-mode time-mode text-mode "Time")

(define-key time-mode-map (kbd "<tab>") 'time-mode-update)
