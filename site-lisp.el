(defun goto-line-sexp ()
  (interactive)
  (beginning-of-line)
  (if (= (point)
         (save-excursion (progn (forward-sexp) (line-beginning-position))))
      (auto-indent/beginning-of-line)
    (end-of-line)
    (backward-sexp)))

(defun lisp-transpose-lines (num)
  (interactive "p")
  (goto-line-sexp)
  (transpose-sexps num))

(defun lisp-delete-line ()
  (interactive)
  (goto-line-sexp)
  (kill-sexp))

(defun lisp-duplicate-line ()
  (interactive)
  (goto-line-sexp)
  (let ((line (buffer-substring (point) (progn (forward-sexp) (point)))))
    (newline-and-indent)
    (insert line)))

(defun site-lisp-init ()
  (paredit-mode)
  (auto-indent-hook)

  (setf auto-indent/delete-char-function 'paredit-forward-delete)
  (setf auto-indent/backward-delete-char-function 'paredit-backward-delete)

  (set-kbd-keys paredit-mode-map
    (")"   . paredit-close-round-and-newline)
    ("C-!" . paredit-backward-slurp-sexp)
    ("C-@" . paredit-forward-slurp-sexp)
    ("M-0" . paredit-close-round)
    ("M-9" . paredit-wrap-round)

    "C-("
    "C-)"
    "C-<left>"
    "C-<right>"
    "M-<up>"
    "M-<down>"
    "<delete>")

  (set-kbd-keys
    ("C-x C-t"       . lisp-transpose-lines)
    ("M-<backspace>" . lisp-delete-line)
    ("C-'"           . lisp-duplicate-line)))

(add-hook 'emacs-lisp-mode-hook 'site-lisp-init)
(add-hook 'scheme-mode-hook 'site-lisp-init)
