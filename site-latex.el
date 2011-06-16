(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)

(definit LaTeX
  (visual-line-mode t)
  (set-kbd-keys
    ("C-S-r" . preview-at-point)))
