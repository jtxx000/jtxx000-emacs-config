(require 'compile)
(load-library "compile")
(add-to-list 'compilation-error-regexp-alist-alist
             '(node-file "^\\(/.+\\):\\([0-9]+\\)" 1 2))
(add-to-list 'compilation-error-regexp-alist-alist
             '(node-stack "^ +at [^(]+(\\(.+\\):\\(.+\\):\\(.+\\))" 1 2 3))
(add-to-list 'compilation-error-regexp-alist 'node-stack t)
(add-to-list 'compilation-error-regexp-alist 'node-file t)
