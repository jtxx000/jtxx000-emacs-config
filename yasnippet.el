(setq yas/dont-activate t)
(setq yas/trigger-key (kbd "SPC"))
(require 'yasnippet-bundle)

(defun yas/add-trigger-key (key)
  (lexical-let ((key* key))
    (define-key yas/minor-mode-map key
      (lambda ()
        (interactive)
        (let ((yas/trigger-key key*))
          (yas/expand))))))

(defun insert-brackets ()
  (interactive)
  (if (and (not (bobp))
               (or (equal 'font-lock-comment-face
                          (get-char-property (1- (point))
                                             'face))
                   (equal 'font-lock-string-face
                          (get-char-property (1- (point))
                                             'face))))
      (insert "{")
    (delete-region (point)
                   (save-excursion
                     (search-backward-regexp "[^ \t\n]")
                     (forward-char)
                     (point)))
    (insert " {")
    (newline)
    (newline-and-indent)
    (insert "}")
    (indent-according-to-mode)
    (previous-line)
    (indent-according-to-mode)))

(yas/add-trigger-key (kbd "<return>"))
(add-hook 'c-mode-common-hook 'yas/minor-mode-on)

(add-hook 'c-mode-hook '(lambda () (local-set-key "{" 'insert-brackets)))

(add-to-list 'yas/key-syntaxes "{")
(add-to-list 'yas/key-syntaxes "(")
(yas/define 'c-mode "{" " {\n$>$0\n}$>")
(yas/define 'c-mode "if" "if (${1:...})\n$>$0")
