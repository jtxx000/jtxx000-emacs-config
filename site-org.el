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
(setq org-mobile-directory "~/.org-mobile/")
(setq org-mobile-inbox-for-pull "~/misc/incoming.org")

;;(setq org-directory "/tmp/org-mobile")

(add-hook 'org-mobile-post-push-hook
          (lambda ()
            (shell-command "ssh codphilosophy.com 'rm -r org-mobile'")
            (shell-command (concat "scp -r " org-mobile-directory " codphilosophy.com:org-mobile"))
            (shell-command (concat "rm -r " org-mobile-directory "*"))))

(add-hook 'org-mobile-pre-pull-hook
          (lambda ()
            (shell-command (concat "scp -r codphilosophy.com:org-mobile/* " org-mobile-directory))))

(add-hook 'org-mobile-post-pull-hook
          (lambda ()
            (shell-command (concat "rm -r " org-mobile-directory "*"))))

; (require 'org-protocol)

;; (setq org-mobile-directory "~/stage/")

;; (add-hook 'org-mobile-post-push-hook
;;           (lambda () (shell-command "scp -r ~/stage/* user@@wdhost:mobile/")))
;; (add-hook 'org-mobile-pre-pull-hook
;;           (lambda () (shell-command "scp user@@wdhost:mobile/mobileorg.org ~/stage/ ")))
;; (add-hook 'org-mobile-post-pull-hook
;;           (lambda () (shell-command "scp ~/stage/mobileorg.org user@@wdhost:mobile/")))

;; (add-hook 'org-mobile-post-push-hook
;;           (lambda () (shell-command "scp -r ~/stage/* user@@wdhost:mobile/")))
;; (add-hook 'org-mobile-pre-pull-hook
;;           (lambda () (shell-command "scp user@@wdhost:mobile/mobileorg.org ~/stage/ ")))
;; (add-hook 'org-mobile-post-pull-hook
;;           (lambda () (shell-command "scp ~/stage/mobileorg.org user@@wdhost:mobile/")))

;; (defadvice org-format-agenda-item (around site-org-agenda-category activate)
;;   (let ((category (or category
;;                       (and buffer-file-name
;;                            (string-equal
;;                             (file-name-sans-extension
;;                              (file-name-nondirectory buffer-file-name))
;;                             "README")
;;                            (file-name-as-directory
;;                             (file-name-nondirectory (substring
;;                                                      (file-name-directory buffer-file-name)
;;                                                      0
;;                                                      -1)))))))
;;     ad-do-it))


(defadvice org-refresh-category-properties (around site-org-refresh-category activate)
  (let ((org-category (or org-category
                          (and buffer-file-name
                               (string-equal
                                (file-name-sans-extension
                                 (file-name-nondirectory buffer-file-name))
                                "README")
                               (file-name-nondirectory (substring
                                                        (file-name-directory buffer-file-name)
                                                        0
                                                        -1))))))
    ad-do-it))
