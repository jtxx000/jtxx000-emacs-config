(require 'rst)

(definit rst
  (set-kbd-keys rst-mode-map ("C-=" . rst-adjust-decoration))
  (auto-fill-mode)
  (setq paragraph-start "\\f\\|[ \\t]*$")
  (setq paragraph-separate "[ \\t\\f]*$")
  (flyspell-mode))
