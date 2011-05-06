(defun site-org-change-mobile-group ()
  (shell-command "chgrp http /srv/http/org/*; chmod g+w /srv/http/org/*"))

(add-hook 'org-mobile-post-push-hook 'site-org-change-mobile-group)

(definit org
  (visual-line-mode)
  (flyspell-mode)
  (setq paragraph-start "\\f\\|[ \\t]*$")
  (setq paragraph-separate "[ \\t\\f]*$"))

(require 'org)
(set-kbd-keys org-mode-map
  ("C-C C-r"  . org-occur)
  "C-e"
  "C-'")

(setq org-default-notes-file "~/misc/notes.org")
