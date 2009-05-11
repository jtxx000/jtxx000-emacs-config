(defun time-mode-insert-time (&optional time)
  (interactive)
  (insert (format-time-string "%Y-%m-%d %H:%M" (or time (current-time)))))

(defun time-mode-forward-time ()
  (search-forward-regexp "^[^ ]+ [^ ]+\\( - \\)" (line-end-position) t))

(defun time-mode-parse-time (b e)
  (time-to-seconds (parse-time (buffer-substring b e))))

(defun time-mode-format-range (r)
  (if r
    (let ((r (/ r 60)))
      (if (< r 60)
          (format "%dm" r)
        (format "%.1fh" (/ r 60))))
    "-"))

(defun time-mode-parse-range ()
  (when (time-mode-forward-time)
    (- (time-mode-parse-time (point) (line-end-position))
       (time-mode-parse-time (line-beginning-position) (point)))))

(defun time-mode-parse-cur-range ()
  (beginning-of-paragraph)
  (time-mode-parse-range))

(defun time-mode-parse-sum ()
  (beginning-of-buffer)
  (loop while (next-paragraph)
        for x = (time-mode-parse-cur-range)
        do (forward-paragraph)
        if x
        sum x))

(defun time-mode-update ()
  (interactive)
  (if (and (is-current-line-whitespace)
           (save-excursion (forward-line -1) (is-current-line-whitespace)))
      (time-mode-insert-time)
    (save-excursion
      (beginning-of-paragraph)
      (when (time-mode-forward-time)
        (backward-char 3)
        (delete-region (point) (line-end-position)))
      (end-of-line)
      (insert " - ")
      (time-mode-insert-time))))

(defun time-mode-update-mode-line ()
  (save-excursion
    (setq time-mode-string
          (concat (time-mode-format-range (time-mode-parse-cur-range))
                  "/"
                  (time-mode-format-range (time-mode-parse-sum)))))
  (force-mode-line-update))

(defun time-mode ()
  (interactive)
  (fundamental-mode)
  (local-set-key (kbd "<tab>") 'time-mode-update))

(defvar time-mode-string "")

(define-derived-mode time-mode text-mode "Time"
  "A mode for keeping track of hours worked."
  (or global-mode-string (setq global-mode-string '("")))
  (unless (memq 'display-time-string global-mode-string)
    (make-variable-buffer-local 'global-mode-string)
    (setq global-mode-string
          (append global-mode-string '(time-mode-string))))
  (add-hook 'post-command-hook 'time-mode-update-mode-line nil t))

(define-key time-mode-map (kbd "<tab>") 'time-mode-update)
