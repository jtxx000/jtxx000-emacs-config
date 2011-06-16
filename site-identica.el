(require 'identica-mode)
(let ((identica (netrc-machine (netrc-parse "~/.authinfo") "identi.ca" t)))
    (setq identica-password (netrc-get identica "password")
          identica-username (netrc-get identica "login")))
