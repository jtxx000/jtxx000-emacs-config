(require 'cc-mode)

(defvar auto-indent/delete-char-function 'delete-char)
(make-variable-buffer-local 'auto-indent/delete-char-function)
(defvar auto-indent/backward-delete-char-function 'backward-delete-char-untabify)
(make-variable-buffer-local 'auto-indent/backward-delete-char-function)

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
      (indent-according-to-mode))))

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

        (indent-according-to-mode))
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
            (indent-according-to-mode)))
    (apply auto-indent/backward-delete-char-function '(1))))


(defun auto-indent/open-line ()
  (interactive)
  (save-excursion
    (newline)
    (indent-according-to-mode)))

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

(defvar auto-indent/last-line 1)
(make-variable-buffer-local 'auto-indent/last-line)
(defvar auto-indent/overlay)
(make-variable-buffer-local 'auto-indent/overlay)

(defvar auto-indent/line-change-hook '())

(defun auto-indent/pre-command ()
  (setq auto-indent/last-line (copy-marker (line-beginning-position))))

(defun auto-indent/is-whitespace (x y &optional no-empty)
  (string-match
   (concat "^[ \t]"
           (if no-empty "+" "*")
           "$")
   (buffer-substring x y)))

(defvar auto-indent/should-splice)
(make-variable-buffer-local  'auto-indent/should-splice)

(defun auto-indent/splice-overlay (o after begin end &optional len)
  (setq auto-indent/should-splice t))

(defun auto-indent/post-command ()
  (when auto-indent/should-splice
    (save-excursion
      (goto-char (overlay-start auto-indent/overlay))
      (delete-overlay auto-indent/overlay)
      (indent-according-to-mode)
      (setq auto-indent/should-splice nil)))
  (c-save-buffer-state ()
      (c-tentative-buffer-changes
        (if (auto-indent/is-whitespace (line-beginning-position) (point))
            (if (auto-indent/is-whitespace (line-beginning-position) (line-end-position))
                (progn
                  (delete-overlay auto-indent/overlay)
                  (indent-according-to-mode)
                  (overlay-put auto-indent/overlay 'before-string (buffer-substring (line-beginning-position) (line-end-position)))
                  (move-overlay auto-indent/overlay (line-beginning-position) (line-end-position)))
              (delete-overlay auto-indent/overlay)
              (auto-indent/beginning-of-line)))
        nil))
  (if (and (/= auto-indent/last-line (line-beginning-position))
           (buffer-modified-p))
      (save-excursion
        (goto-char auto-indent/last-line)
        (if (auto-indent/is-whitespace (point) (line-end-position) t)
            (delete-region (point) (line-end-position))))))

(defun auto-indent-hook ()
  (interactive)
  (local-set-key [left] 'auto-indent/backward-char)
  (local-set-key [return] 'newline-and-indent)
  (local-set-key [delete] 'auto-indent/delete-char)
  (local-set-key (kbd "C-d") 'auto-indent/delete-char)
  (local-set-key [backspace] 'auto-indent/backward-delete-char)
  (local-set-key [home] 'auto-indent/beginning-of-line)
  (if (system-is-osx)
      (local-set-key (kbd "A-<left>") 'auto-indent/beginning-of-line))
  (local-set-key (kbd "C-o") 'auto-indent/open-line)
  (local-set-key (kbd "C-y") 'auto-indent/yank)
  (local-set-key (kbd "M-y") 'auto-indent/yank-pop)
  (add-hook 'pre-command-hook 'auto-indent/pre-command nil t)
  (add-hook 'post-command-hook 'auto-indent/post-command nil t)
  (setq auto-indent/overlay (make-overlay (point-min)
                                          (point-min)))
  (overlay-put auto-indent/overlay 'invisible t)
  (overlay-put auto-indent/overlay 'insert-behind-hooks '(auto-indent/splice-overlay))
  (delete-overlay auto-indent/overlay))

(add-hook 'ruby-mode-hook 'auto-indent-hook)
