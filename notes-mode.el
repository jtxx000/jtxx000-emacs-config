(defvar notes-mode-section-regexp "^== .* ==$")

(add-to-list 'magic-mode-alist (cons notes-mode-section-regexp 'notes-mode))

(defun notes-mode-insert-section ()
  (interactive)
  (insert "== ")
  (save-excursion (insert " ==")))

(define-derived-mode notes-mode text-mode "Notes"
  (define-key notes-mode-map (kbd "C-=") 'notes-mode-insert-section)
  (setq font-lock-defaults
        `(((,notes-mode-section-regexp . font-lock-function-name-face)
           ("^\\?* ?\\(.*\\) - " 1 font-lock-type-face)
           ("^\\([[:digit:]]\\{2\\}\\): " . 1)
           "@"
           ("@ \\(.*\\)$" 1 font-lock-constant-face)))))
