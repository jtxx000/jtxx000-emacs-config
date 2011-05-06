(require 'calendar)
(set-kbd-keys calendar-mode-map
  "C-p"
  "C-b")

(add-to-list 'cycle-buffer-filter '(not (string-equal (buffer-name) "*Calendar*")))
