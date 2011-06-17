(defvar auto-indent/delete-char-function 'delete-char)
(make-variable-buffer-local 'auto-indent/delete-char-function)
(defvar auto-indent/backward-delete-char-function 'backward-delete-char-untabify)
(make-variable-buffer-local 'auto-indent/backward-delete-char-function)

(defun auto-indent/indent-if-needed ()
  (unless (auto-indent/is-whitespace (line-beginning-position) (line-end-position))
    (indent-according-to-mode)))

(defun auto-indent/point-at-beginning-of-line-text ()
  (<= (point)
      (save-excursion
        (back-to-indentation)
        (point))))

(defun auto-indent/backward-char ()
  (interactive)
  (when (auto-indent/point-at-beginning-of-line-text)
    (beginning-of-line))
  (backward-char))

(defun auto-indent/delete-char ()
  (interactive)
  (if (= (point) (line-end-position))
      (progn (delete-indentation t)
             (save-restriction
               (narrow-to-region (point-at-bol) (point-at-eol))
               (delete-trailing-whitespace)))
    (apply auto-indent/delete-char-function '(1))))

(defun auto-indent/backward-delete-char ()
  (interactive)
  (if (auto-indent/point-at-beginning-of-line-text)
      (progn (delete-indentation)
             (save-restriction
               (narrow-to-region (point-at-bol) (point-at-eol))
               (delete-trailing-whitespace))
             (indent-according-to-mode))
    (apply auto-indent/backward-delete-char-function '(1))))

(defun auto-indent/open-line ()
  (interactive)
  (save-excursion
    (newline)
    (auto-indent/indent-if-needed)))

(defun auto-indent/yank ()
  (interactive)
  (setq this-command 'yank)
  (yank)
  (indent-region (mark t) (point)))

(defun auto-indent/yank-pop ()
  (interactive)
  (setq this-command 'yank)
  (yank-pop)
  (indent-region (mark t) (point)))

(defvar auto-indent/last-line)
(make-variable-buffer-local 'auto-indent/last-line)

(defvar auto-indent/line-change-hook '())

(defun auto-indent/pre-command ()
  (set-marker auto-indent/last-line (line-beginning-position)))

(defun auto-indent/is-whitespace (x y &optional no-empty)
  (string-match
   (concat "^[ \t]"
           (if no-empty "+" "*")
           "$")
   (buffer-substring x y)))

(defun auto-indent/post-command ()
  (unless undo-in-progress
    (let ((undo-list buffer-undo-list)
          (in-undo-block (car buffer-undo-list)))
      (let ((mod (buffer-modified-p))
            (buffer-undo-list (if in-undo-block
                                  buffer-undo-list
                                (cdr buffer-undo-list)))
            (inhibit-read-only t)
            (inhibit-point-motion-hooks t)
            before-change-functions
            after-change-functions
            deactivate-mark
            buffer-file-name
            buffer-file-truename)
        (when (and (/= auto-indent/last-line (line-beginning-position))
                   (not (memq this-command '(undo redo))))
          (save-excursion
            (goto-char auto-indent/last-line)
            (if (auto-indent/is-whitespace (point) (line-end-position) t)
                (delete-region (point) (line-end-position))))
          (if (auto-indent/is-whitespace (line-beginning-position) (point))
              (if (auto-indent/is-whitespace (line-beginning-position) (line-end-position))
                  (indent-according-to-mode)
                (back-to-indentation)))
          (run-hooks 'auto-indent/line-change-hook))
        (and (not mod)
             (buffer-modified-p)
             (set-buffer-modified-p nil))
        (setq undo-list (if in-undo-block
                            buffer-undo-list
                          (cons nil buffer-undo-list))))
      (setq buffer-undo-list undo-list))))

(define-minor-mode auto-indent-mode
  "Minor mode for automatically indenting source code"
  :keymap
  '(([left]      . auto-indent/backward-char)
    ("\C-b"      . auto-indent/backward-char)
    ([return]    . newline-and-indent)
    ([delete]    . auto-indent/delete-char)
    ("\C-d"      . auto-indent/delete-char)
    ([backspace] . auto-indent/backward-delete-char)
    ([home]      . back-to-indentation)
    ("\C-o"      . auto-indent/open-line)
    ("\C-y"      . auto-indent/yank)
    ("\M-y"      . auto-indent/yank-pop))
  (if auto-indent-mode
      (progn
        (setq auto-indent/last-line (make-marker))
        (add-hook 'pre-command-hook 'auto-indent/pre-command nil t)
        (add-hook 'post-command-hook 'auto-indent/post-command nil t)
        (auto-indent/pre-command))
    (remove-hook 'pre-command-hook 'auto-indent/pre-command t)
    (remove-hook 'post-command-hook 'auto-indent/post-command t)))

(provide 'auto-indent)
