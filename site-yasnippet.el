(setq yas/dont-activate t)
(setq yas/trigger-key (kbd "SPC"))
(require 'yasnippet)

(add-hook 'c-mode-common-hook 'yas/minor-mode-on)

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