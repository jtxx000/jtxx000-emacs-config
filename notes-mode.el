(defvar notes-mode-section-regexp "^== .* ==$")

(add-to-list 'magic-mode-alist (cons notes-mode-section-regexp 'notes-mode))

(define-derived-mode notes-mode text-mode "Notes"
  (setq font-lock-defaults
        `(((,notes-mode-section-regexp . font-lock-function-name-face)
           ("^\\(.*\\) - " 1 font-lock-type-face)
           ("^\\([[:digit:]]\\{2\\}\\): " . 1)
           "@"
           ("@ \\(.*\\)$" 1 font-lock-constant-face)))))
