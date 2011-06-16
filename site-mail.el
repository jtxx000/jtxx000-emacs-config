(setq smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil)) ; Must be set BEFORE loading smtpmail
      smtpmail-auth-credentials (expand-file-name "~/.authinfo")
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      smtpmail-debug-info t ; change to nil once it works
      smtpmail-debug-verb t)
(require 'smtpmail)
(setq message-send-mail-function 'smtpmail-send-it)
(require 'starttls)
(require 'notmuch)
