(defun goto-line-sexp ()
  (interactive)
  (beginning-of-line)
  (if (= (point)
         (save-excursion (progn (forward-sexp) (line-beginning-position))))
      (back-to-indentation)
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
  (save-excursion
    (goto-line-sexp)
    (let ((line (buffer-substring (point) (progn (forward-sexp) (point)))))
      (newline-and-indent)
      (insert line)))
  (next-line))

(defun lisp-close-space ()
  (interactive)
  (paredit-close-round)
  (insert " "))

(defun lisp-update-section-comment ()
  (interactive)
  (update-section-comment ?\;))

(definit (lisp emacs-lisp-mode-hook)
  (paredit-mode)
  (set (make-local-variable 'autopair-dont-activate) t)
  (auto-indent-mode)

  (setf auto-indent/delete-char-function 'paredit-forward-delete)
  (setf auto-indent/backward-delete-char-function 'paredit-backward-delete)

  (set-kbd-keys paredit-mode-map
    (")"             . paredit-close-round-and-newline)
    ("]"             . lisp-close-space)
    ("C-!"           . paredit-backward-slurp-sexp)
    ("C-@"           . paredit-forward-slurp-sexp)
    ("C-<backspace>" . paredit-backward-kill-word)
    ("C-<delete>"    . paredit-forward-kill-word)
    ("S-<end>"       . paredit-close-round)
    ("M-9"           . paredit-wrap-round)

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
    ("C-'"           . lisp-duplicate-line)
    ("C-="           . lisp-update-section-comment)))

(require 'rainbow-delimiters)
(setq-default frame-background-mode 'dark)

;;;; scheme
(definit scheme
  (site-lisp-init)
  ;(set (make-local-variable 'autopair-dont-activate) t)
  (set-kbd-keys
    ("C-c C-d" . geiser-doc-look-up-manual)))

(put 'match 'scheme-indent-function 1)
(put 'match-let 'scheme-indent-function 1)
(put 'match-lambda 'scheme-indent-function 1)
(put 'receive 'scheme-indent-function 2)
(put 'with 'scheme-indent-function 2)
(put 'redefine 'scheme-indent-function 1)
