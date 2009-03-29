(global-set-kbd-key "C-p"           'cycle-buffer)
(global-set-kbd-key "C-z"           'kill-current-buffer)
(global-set-kbd-key "C-n"           'save-buffer)
(global-set-kbd-key "C-f"           'find-file)
(global-set-kbd-key "C-b"           'switch-to-buffer)
(global-set-kbd-key "M-1"           'delete-other-windows)
(global-set-kbd-key "C-'"           'duplicate-line)
(global-set-kbd-key "C-<return>"    'newline-under)
(global-set-kbd-key "C-;"           'newline-over)
(global-set-kbd-key "<f8>"          'undo)
(global-set-kbd-key "C-("           'kmacro-start-macro)
(global-set-kbd-key "C-)"           'kmacro-end-macro)
(global-set-kbd-key "C-*"           'kmacro-end-and-call-macro)

(if (not (system-is-osx))
    (global-set-kbd-key "M-<backspace>" 'kill-entire-line))

(if (system-is-osx)
    (progn
      (global-set-kbd-key "M-<up>" 'backward-paragraph)
      (global-set-kbd-key "M-<down>" 'forward-paragraph)
      (global-set-kbd-key "A-w" 'kill-this-buffer)
      (global-set-kbd-key "A-f" 'find-file)
      (global-set-kbd-key "A-q" 'kill-emacs)
      (global-set-kbd-key "A-<up>" 'beginning-of-buffer)
      (global-set-kbd-key "A-<down>" 'end-of-buffer)
      (global-set-kbd-key "A-<left>" 'beginning-of-line)
      (global-set-kbd-key "A-<right>" 'end-of-line)
      (global-set-kbd-key "A-<backspace>" 'kill-entire-line)
      (global-set-kbd-key "A-s" 'save-buffer)))