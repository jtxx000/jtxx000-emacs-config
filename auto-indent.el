(require 'cc-mode)

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
    (c-save-buffer-state ()
      (c-tentative-buffer-changes
        (cond
         (line-white (indent-according-to-mode)
                     (overlay-put auto-indent/overlay 'before-string (buffer-substring (line-beginning-position) (line-end-position))))
         (at-white (auto-indent/beginning-of-line)))
        nil))
    (if line-white
        (move-overlay auto-indent/overlay (line-beginning-position) (line-end-position))))

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

(defun c-tnt-chng-cleanup (keep saved-state)
  ;; Used internally in `c-tentative-buffer-changes'.

  (let ((saved-undo-list (elt saved-state 0)))
    (if (eq buffer-undo-list saved-undo-list)
        ;; No change was done afterall.
        (setq buffer-undo-list (cdr saved-undo-list))

      (if keep
          ;; Find and remove the undo boundary.
          (let ((p buffer-undo-list))
            (while (not (eq (cdr p) saved-undo-list))
              (setq p (cdr p)))
            (setcdr p (cdr saved-undo-list)))

        ;; `primitive-undo' will remove the boundary.
        (setq saved-undo-list (cdr saved-undo-list))
        (let ((undo-in-progress t))
          (while (and buffer-undo-list
                      (not (eq (setq buffer-undo-list
                                     (primitive-undo 1 buffer-undo-list))
                               saved-undo-list)))))

        (when (buffer-live-p (elt saved-state 1))
          (set-buffer (elt saved-state 1))
          (goto-char (elt saved-state 2))
          (set-mark (elt saved-state 3))
          (c-set-region-active (elt saved-state 4))
          (and (not (elt saved-state 5))
               (buffer-modified-p)
               (set-buffer-modified-p nil)))))))

(provide 'auto-indent)
