(definit geiser-repl
  (paredit-mode)
  (set-kbd-keys
    ("C-S-r" . comint-history-isearch-backward-regexp)))
