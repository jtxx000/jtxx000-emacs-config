(definit geiser-repl
  (paredit-mode)
  (set-kbd-keys
    ("C-S-r"   . comint-history-isearch-backward-regexp)
    ("C-c C-d" . geiser-doc-look-up-manual)))

(require 'geiser-mode)
(set-kbd-keys geiser-mode-map
  "C-c C-d")
