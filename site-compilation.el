(defvar compilation-output-file nil)

(defun site-compilation-finish (buffer string)
  (cond ((string-match "finished" string)
         (bury-buffer "*compilation*")
         (winner-undo)
         (message "Build successful."))
        (t (message "Compilation exited abnormally: %s" string)))
  (when compilation-output-file
    (display-file compilation-output-file)))

(add-to-list 'compilation-finish-functions 'site-compilation-finish)