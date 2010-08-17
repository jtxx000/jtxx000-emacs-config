(defun insert-brackets ()
  (interactive)
  (if (and (not (bobp))
               (or (equal 'font-lock-comment-face
                          (get-char-property (1- (point))
                                             'face))
                   (equal 'font-lock-string-face
                          (get-char-property (1- (point))
                                             'face))))
      (insert "{")
    (delete-region (point)
                   (save-excursion
                     (search-backward-regexp "[^ \t\n]")
                     (forward-char)
                     (point)))
    (insert " {")
    (newline)
    (newline-and-indent)
    (insert "}")
    (indent-according-to-mode)
    (previous-line)
    (indent-according-to-mode)))

(defun c-esque/is-at-end-of-line ()
  (and (= (point) (line-end-position))
        (/= (point) 1)
        (string= (buffer-substring (point) (1- (point))) ";")))

(defun c-esque/end-of-line ()
  (interactive)
  (let ((old-point (point)))
    (end-of-line)
    (c-esque/confine-to-line-end)
    (if (<= (point) old-point)
        (end-of-line))))

(defun c-esque/confine-to-line-end ()
  (interactive)
  (if (c-esque/is-at-end-of-line) (backward-char)))

(defun c-esque/forward-char ()
  (interactive)
  (forward-char)
  (if (c-esque/is-at-end-of-line)
      (forward-char)))

(defun c-esque/newline ()
  (interactive)
  (if (or (= (point) (point-max))
          (save-excursion (forward-char) (c-esque/is-at-end-of-line)))
      (newline-under)
    (newline-and-indent)))

(defun c-esque-update-section-comment ()
  (interactive)
  (let* ((str (buffer-substring (line-beginning-position) (line-end-position)))
         (m (if (string-match "^/* ?\\(.*?\\) ?/*$" str) (match-string 1 str) ""))
         (p (point)))
    (delete-region (line-beginning-position) (line-end-position))
    (insert-char ?/ 4)
    (if (string= m "") (insert " ")
      (insert " " m " ")
      (insert-char ?/ (- 80 (current-column)))
      (goto-char p))))

(defun c-esque-insert-doxygen-comment ()
  (interactive)
  (end-of-line)
  (c-beginning-of-statement-1)
  (insert "/**\n\n*/\n")
  (forward-line -2))

(definit (c-esque c-mode-common-hook)
  (auto-indent-hook)
  (flyspell-prog-mode)
  (auto-fill-mode)
  (c-subword-mode)

  (set-kbd-keys
    ("{"        . insert-brackets)
    ("<end>"    . c-esque/end-of-line)
    ("<right>"  . c-esque/forward-char)
    ("<return>" . c-esque/newline)
    ("C-c C-s"  . c-esque-update-section-comment))

  (if (system-is-osx)
      (set-kbd-keys ("A-<right>" . c-esque/end-of-line)))

  (c-set-offset 'substatement-open 0)
  (add-hook 'auto-indent/line-change-hook 'c-esque/confine-to-line-end nil t))
