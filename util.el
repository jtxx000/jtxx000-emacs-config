(defmacro global-set-kbd-key (key cmd)
  (list 'global-set-key (list 'kbd key) cmd))

(defun delete-first (elt list)
  (if (equal (car list) elt)
      (cdr list)
    (let ((total list))
      (while (and (cdr list)
                  (not (equal (cadr list) elt)))
        (setq list (cdr list)))
      (when (cdr list)
        (setcdr list (cddr list)))
      total)))

(defun kill-current-buffer ()
  (interactive)
  (kill-buffer nil))

(defun kill-entire-line ()
  (interactive)
  (let ((c (current-column)))
    (kill-whole-line 1)
    (move-to-column c)))

(defun duplicate-line ()
  (interactive)
  (save-excursion
    (let ((line (buffer-substring (line-beginning-position) (line-end-position))))
      (end-of-line)
      (newline)
      (insert line)))
  (next-line))

(defun newline-under ()
  (interactive)
  (end-of-line)
  (newline-and-indent))

(defun newline-over ()
  (interactive)
  (beginning-of-line)
  (split-line)
  (indent-according-to-mode))

(defun system-is-osx ()
  (string-match "apple" system-configuration))

(defun parse-time (s)
  (apply 'encode-time
         (loop repeat 6 for x in (parse-time-string s) collect (or x 0))))

(defun is-horizontal-whitespace (s)
  (string-match "\\`[\n\t ]*\\'" s))

(defun is-current-line-whitespace ()
  (is-horizontal-whitespace (buffer-substring (line-beginning-position)
                                              (line-end-position))))
