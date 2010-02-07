(defun site-org-change-mobile-group ()
  (shell-command "chgrp http /srv/http/org/*; chmod g+w /srv/http/org/*"))

(add-hook 'org-mobile-post-push-hook 'site-org-change-mobile-group)

(setq org-agenda-custom-commands
      '(("t" tags "test" ((org-agenda-prefix-format "  % s")
                          (org-agenda-sorting-strategy '(time-up))))
        ("p" tags "proj")))