(defvar auto-indent/delete-char-function 'delete-char)
(make-variable-buffer-local 'auto-indent/delete-char-function)
(defvar auto-indent/backward-delete-char-function 'backward-delete-char-untabify)
(make-variable-buffer-local 'auto-indent/backward-delete-char-function)

(defun auto-indent/indent-if-needed ()
  (unless (auto-indent/is-whitespace (line-beginning-position) (line-end-position))
    (indent-according-to-mode)))

(defun auto-indent/backward-char ()
  (interactive)
  (if (auto-indent/point-at-beginning-of-line-text)
      (progn (beginning-of-line)
             (backward-char))
    (backward-char)))

(defun auto-indent/beginning-of-line ()
  (interactive)
  (beginning-of-line)
  (save-match-data
    (if (search-forward-regexp "[^ \t]" nil t)
        (backward-char)
      (end-of-line))))

(defun auto-indent/point-at-beginning-of-line-text ()
  (<= (point)
      (let ((old-p (point-marker)))
        (set-marker-insertion-type old-p t)
        (auto-indent/beginning-of-line)
        (let ((p (point)))
          (goto-char old-p)
          p))))

(defun auto-indent/delete-char ()
  (interactive)
  (if (= (point) (line-end-position))
      (progn
        (delete-region (point)
                       (progn (next-line)
                              (auto-indent/beginning-of-line)
                              (point)))

        (auto-indent/indent-if-needed))
    (apply auto-indent/delete-char-function '(1))))

(defun auto-indent/backward-delete-char ()
  (interactive)
  (if (auto-indent/point-at-beginning-of-line-text)
      (progn
        (delete-region (point)
                       (progn (previous-line)
                              (end-of-line)
                              (point)))
        (if (auto-indent/is-whitespace (line-beginning-position) (point))
            (auto-indent/indent-if-needed)))
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

(defvar auto-indent/overlay)
(make-variable-buffer-local 'auto-indent/overlay)

(defun auto-indent/is-whitespace (x y &optional no-empty)
  (string-match
   (concat "^[ \t]"
           (if no-empty "+" "*")
           "$")
   (buffer-substring x y)))

(defvar auto-indent/last-line-unless-white)
(make-variable-buffer-local 'auto-indent/last-line-unless-white)

(defun auto-indent/can-change ()
  (and (buffer-modified-p)
       (not (or (eq this-command 'undo)
                (eq this-command 'redo)))))

(defun auto-indent/pre-command ()
  (setq auto-indent/last-line-unless-white (unless (auto-indent/is-whitespace (line-beginning-position) (line-end-position) t)
                                             (copy-marker (line-beginning-position)))))

(defmacro auto-indent/temp-change (&rest forms)
  "Executes FORMS with a temporary buffer-undo-list, undoing on return.
The changes you make within FORMS are undone before returning.
But more importantly, the buffer's buffer-undo-list is not affected.
This allows you to temporarily modify read-only buffers too."
  `(let* ((buffer-undo-list)
          (modified (buffer-modified-p))
          (inhibit-read-only t))
     (save-excursion
       (unwind-protect
           (progn ,@forms)
         (primitive-undo (length buffer-undo-list) buffer-undo-list)
         (set-buffer-modified-p modified))) ()))
(put 'auto-indent/temp-change 'lisp-indent-function 0)

(defun auto-indent/post-command ()
  (save-excursion
    (when (and (overlay-buffer auto-indent/overlay)
               (not (progn (goto-char (overlay-start auto-indent/overlay))
                           (auto-indent/is-whitespace (line-beginning-position) (line-end-position)))))
      (delete-overlay auto-indent/overlay)
      (if (auto-indent/can-change)
          (indent-according-to-mode))))

  (let ((at-white (auto-indent/is-whitespace (line-beginning-position) (point)))
        (line-white (auto-indent/is-whitespace (line-beginning-position) (line-end-position))))
    (delete-overlay auto-indent/overlay)
    (cond
     (line-white (auto-indent/temp-change
                   (indent-according-to-mode)
                   (overlay-put auto-indent/overlay 'before-string (buffer-substring (line-beginning-position) (line-end-position))))
                 (move-overlay auto-indent/overlay (line-beginning-position) (line-end-position)))
     (at-white (auto-indent/beginning-of-line))))

  (and (auto-indent/can-change)
       auto-indent/last-line-unless-white
       (save-excursion
         (goto-char auto-indent/last-line-unless-white)
         (if (auto-indent/is-whitespace (line-beginning-position) (line-end-position) t)
             (delete-region (line-beginning-position) (line-end-position))))))

(define-minor-mode auto-indent-mode
  "Minor mode for automatically indenting source code"
  :keymap
  '(([left]      . auto-indent/backward-char)
    ("\C-b"      . auto-indent/backward-char)
    ([return]    . newline-and-indent)
    ([delete]    . auto-indent/delete-char)
    ("\C-d"      . auto-indent/delete-char)
    ([backspace] . auto-indent/backward-delete-char)
    ([home]      . auto-indent/beginning-of-line)
    ("\C-o"      . auto-indent/open-line)
    ("\C-y"      . auto-indent/yank)
    ("\M-y"      . auto-indent/yank-pop))
  (if auto-indent-mode
      (progn
        (add-hook 'pre-command-hook 'auto-indent/pre-command nil t)
        (add-hook 'post-command-hook 'auto-indent/post-command nil t)
        (setq auto-indent/overlay (make-overlay (point-min)
                                                (point-min)))
        (overlay-put auto-indent/overlay 'invisible t)
        (auto-indent/pre-command))
    (remove-hook 'pre-command-hook 'auto-indent/pre-command t)
    (remove-hook 'post-command-hook 'auto-indent/post-command t))
  (delete-overlay auto-indent/overlay))

(provide 'auto-indent)
