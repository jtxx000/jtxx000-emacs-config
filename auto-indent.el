(defun auto-indent/backward-char ()
  (interactive)
  (if (auto-indent/point-at-beginning-of-line-text)
      (progn (beginning-of-line)
             (backward-char)
             (indent-according-to-mode))
    (backward-char)))

(defun auto-indent/beginning-of-line ()
  (interactive)
  (beginning-of-line)
  (indent-according-to-mode))

(defun auto-indent/point-at-beginning-of-line-text ()
  (<= (point)
      (save-excursion
        (auto-indent/beginning-of-line)
        (point))))

(defun auto-indent/delete-char ()
  (interactive)
  (if (= (point) (line-end-position))
      (progn
        (delete-region (point)
                       (progn (next-line)
                              (auto-indent/beginning-of-line)
                              (point))))
    (delete-char 1)))

(defun auto-indent/backward-delete-char ()
  (interactive)
  (if (auto-indent/point-at-beginning-of-line-text)
      (progn
        (delete-region (point)
                       (progn (previous-line)
                              (end-of-line)
                              (point))))
    (backward-delete-char-untabify 1)))

(defvar auto-indent/last-line 1)
(make-variable-buffer-local 'auto-indent/last-line)

(defun auto-indent/pre-command ()
  (setq auto-indent/last-line (line-beginning-position)))

(defun auto-indent/post-command ()
  (if (/= auto-indent/last-line (line-beginning-position))
      (progn
        (save-excursion
          (goto-char auto-indent/last-line)
          (if (string-match "^[ \t]+$" (buffer-substring (point) (line-end-position)))
              (delete-region (point) (line-end-position))))
        (indent-according-to-mode))))

(defun auto-indent-hook ()
  (interactive)
  (local-set-key [left] 'auto-indent/backward-char)
  (local-set-key [return] 'newline-and-indent)
  (local-set-key [delete] 'auto-indent/delete-char)
  (local-set-key [backspace] 'auto-indent/backward-delete-char)
  (local-set-key [home] 'auto-indent/beginning-of-line)
  (add-hook 'pre-command-hook 'auto-indent/pre-command nil t)
  (add-hook 'post-command-hook 'auto-indent/post-command nil t))

(add-hook 'c-mode-hook 'auto-indent-hook)
(add-hook 'emacs-lisp-mode-hook 'auto-indent-hook)
