(setq yas/dont-activate t)
(setq yas/trigger-key (kbd "SPC"))
(require 'yasnippet)

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

(add-hook 'c-mode-common-hook 'yas/minor-mode-on)

(add-hook 'c-mode-common-hook '(lambda () (local-set-key "{" 'insert-brackets)))

(yas/define-snippets 'c-esque-mode
                     '(("if" "if ($1)\n$>$0")
                       ("for" "for (${1:int i=0}; ${2:i<n}; ${3:i++})\n$>$0")
                       ("while" "while ($1)\n$>$0")))

(yas/define-snippets 'cc-mode '(("struct" "struct $1 {\n$>$0\n};$>")) 'c-eqsue-mode)

(yas/define-snippets 'd-mode
                     '(("class" "class $1 {\npublic:$>\n$>$0\n}$>")
                       ("foreach" "foreach (${1:i}, ${2:e}; ${3:arr})\n$>$0"))
                     'c-esque-mode)

(yas/define-snippets 'c-mode '() 'cc-mode)

(yas/define-snippets 'c++-mode
                     '(("class" "class $1 {\npublic:$>\n$>$0\n};$>"))
                     'cc-mode)