(defun time-mode-format-time (&optional time)
  (format-time-string "%Y-%m-%d %H:%M" (or time (current-time))))

(defvar time-mode-regexp
  (let* ((m (concat
             "\\([[:digit:]]\\{4\\}-[[:digit:]]\\{2\\}-[[:digit:]]\\{2\\}"
             " "
             "[[:digit:]]\\{2\\}:[[:digit:]]\\{2\\}\\)")))
    (concat "^" m "\\( - " m "\\)?$")))

(defun time-mode-parse-time (i)
  (time-to-seconds (parse-time (match-string i))))

(defun time-mode-format-range (r)
  (let ((r (/ r 60)))
    (if (< r 60)
        (format "%dm" r)
      (format "%.1fh" (/ r 60)))))

(defun time-mode-parse-range ()
  (if (match-string 3)
      (- (time-mode-parse-time 3) (time-mode-parse-time 1))
    0))

(defun time-mode-parse-cur-range ()
  (end-of-line)
  (if (search-backward-regexp time-mode-regexp nil t)
      (time-mode-parse-range)
    0))

(defun time-mode-parse-sum ()
  (goto-char (point-min))
  (loop while (search-forward-regexp time-mode-regexp nil t)
        sum (time-mode-parse-range)
        do (end-of-line)))

(defun time-mode-update ()
  (interactive)
  (let ((cur-time (time-mode-format-time)))
    (if (and (is-current-line-whitespace)
             (save-excursion (forward-line -1) (is-current-line-whitespace)))
        (insert cur-time)
      (let ((beg (line-beginning-position))
            (goto-point (point-marker)))
        (end-of-line)
        (search-backward-regexp time-mode-regexp)
        (unless (or (string= (match-string 1) cur-time)
                    (string= (match-string 3) cur-time))
          (when (match-string 3)
            (delete-region (match-end 1) (line-end-position)))
          (end-of-line)
          (insert " - " cur-time)
          (if (= beg (line-beginning-position))
            (setq goto-point (line-end-position))))
        (goto-char goto-point)))))

(defun time-mode-update-mode-line ()
  (save-excursion
    (setq time-mode-string
          (concat (time-mode-format-range (time-mode-parse-cur-range))
                  "/"
                  (time-mode-format-range (time-mode-parse-sum))))
    (force-mode-line-update)))

(defun time-mode ()
  (interactive)
  (fundamental-mode)
  (local-set-key (kbd "<tab>") 'time-mode-update))

(defvar time-mode-string "")

(defvar time-mode-keywords
  `((,time-mode-regexp . font-lock-function-name-face)))

(define-derived-mode time-mode text-mode "Time"
  "A mode for keeping track of hours worked."
  (setq font-lock-defaults '(time-mode-keywords))
  (or global-mode-string (setq global-mode-string '("")))
  (unless (memq 'display-time-string global-mode-string)
    (make-variable-buffer-local 'global-mode-string)
    (setq global-mode-string
          (append global-mode-string '(time-mode-string))))
  (add-hook 'post-command-hook 'time-mode-update-mode-line nil t))

(define-key time-mode-map (kbd "<tab>") 'time-mode-update)
