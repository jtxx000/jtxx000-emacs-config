(defun site-c++-hook ()
  (if (and (= (buffer-size) 0)
           (string= (car (last (split-string (buffer-file-name) "\\."))) "h"))
      (let ((htext (upcase (let
                               ((case-fold-search nil)
                                (str (car (last (split-string (buffer-file-name) "/")))))
                             (message str)
                             (concat (string (string-to-char str))
                                     (replace-regexp-in-string "\[A-Z\]" "_\\&"
                                                               (replace-regexp-in-string "\\." "_" str)
                                                               nil nil nil 1))))))
        (insert (concat
                 "#ifndef " htext "\n"
                 "#define " htext "\n\n\n\n"
                 "#endif //" htext))
        (previous-line 2)))
  (when (and (= (buffer-size) 0)
             (string= (car (last (split-string (buffer-file-name) "\\."))) "cpp"))
        (insert (concat "#include \""
                        (replace-regexp-in-string "\\.cpp$" ".h" (car (last (split-string (buffer-file-name) "/"))))
                        "\"\n\n"))
        (end-of-buffer)))

(add-hook 'c++-mode-hook 'site-c++-hook)