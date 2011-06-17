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
  (and (c-esque/is-at-end-of-line)
       (not mark-active)
       (backward-char)))

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
    (newline)))

(defun c-esque-update-section-comment ()
  (interactive)
  (update-section-comment ?/))

(defun c-esque-insert-doxygen-comment ()
  (interactive)
  (end-of-line)
  (c-beginning-of-statement-1)
  (insert "/**\n\n*/\n")
  (forward-line -2))

(definit (c-esque c-mode-common-hook)
  (set-kbd-keys
    ("{"        . insert-brackets)
    ("<end>"    . c-esque/end-of-line)
    ("<right>"  . c-esque/forward-char)
    ("C-="      . c-esque-update-section-comment)
    ("<return>" . c-esque/newline))

  (preserve-key-bindings "<return>")

  ;(add-to-list 'minor-mode-overriding-map-alist
               ;(cons t (easy-mmode-define-keymap `(([return] . ,(key-binding [return]))))))

  (auto-indent-mode)
  (flyspell-prog-mode)
  (auto-fill-mode)
  (subword-mode)

  (set-kbd-keys c-mode-map
    "C-c C-a")

  (if (system-is-osx)
      (set-kbd-keys ("A-<right>" . c-esque/end-of-line)))

  (c-set-offset 'substatement-open 0)
  (add-hook 'auto-indent/line-change-hook 'c-esque/confine-to-line-end nil t))

(definit js
  (auto-indent-mode)
  (subword-mode)
  (set-kbd-keys
    ("<end>"   . c-esque/end-of-line)
    ("<right>" . c-esque/forward-char)
    ("C-="     . c-esque-update-section-comment))
  (add-hook 'auto-indent/line-change-hook 'c-esque/confine-to-line-end nil t))
