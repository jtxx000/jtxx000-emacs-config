(defun delete-first (elt list)
  (if (equal (car list) elt)
      (cdr list)
    (let ((total list))
      (while (and (cdr list)
                  (not (equal (cadr list) elt)))
        (setq list (cdr list)))
      (when (cdr list)
        (setcdr list (cddr list)))
      total)))

(defun kill-current-buffer ()
  (interactive)
  (kill-buffer nil))

(defun kill-entire-line (num)
  (interactive "p")
  (let ((c (current-column)))
    (kill-whole-line num)
    (move-to-column c)))

(defun duplicate-line (num)
  (interactive "p")
  (save-excursion
    (let ((line (buffer-substring (line-beginning-position) (line-end-position))))
      (end-of-line)
      (loop repeat num do (newline) (insert line))))
  (next-line num))

(defun newline-under ()
  (interactive)
  (end-of-line)
  (newline))

(defun newline-over ()
  (interactive)
  (beginning-of-line)
  (split-line))

(defun system-is-osx ()
  (string-match "apple" system-configuration))

(defun parse-time (s)
  (apply 'encode-time
         (loop repeat 6 for x in (parse-time-string s) collect (or x 0))))

(defun is-horizontal-whitespace (s)
  (string-match "\\`[\n\t ]*\\'" s))

(defun is-current-line-whitespace ()
  (is-horizontal-whitespace (buffer-substring (line-beginning-position)
                                              (line-end-position))))
(defun kill-ring-save-buffer ()
  (interactive)
  (kill-ring-save (point-min) (point-max)))

(defun kill-ring-save-line ()
  (interactive)
  (kill-ring-save (line-beginning-position) (line-end-position)))

(defun increment-word ()
  (interactive)
  (save-excursion
    (mark-word)
    (let ((r (delete-and-extract-region (region-beginning) (region-end))))
      (insert (number-to-string (+ 1 (string-to-number r))))))
  (forward-word))

(defmacro set-kbd-keys (&rest rst)
  (declare (indent defun))
  (let* ((kmap (if (symbolp (car rst))
                   (car rst)
                 nil))
         (bindings (if kmap (cdr rst) rst))
         (fn (cond ((eq kmap 'global) '(global-set-key))
                   (kmap `(define-key ,kmap))
                   (t '(local-set-key)))))
    `(progn ,@(loop for x in bindings collect
                    `(,@fn (kbd ,(if (listp x) (car x) x))
                           ,(if (listp x) `',(cdr x) nil))))))

(defmacro definit (name-sym &rest body)
  (declare (indent defun))
  (let* ((name-syms (if (listp name-sym)
                        name-sym
                      (list name-sym (intern (concat (symbol-name name-sym) "-mode-hook")))))
         (init-sym (intern (concat "site-"
                                   (symbol-name (car name-syms))
                                   "-init"))))
    `(progn
       (defun ,init-sym () (interactive) ,@body)
       ,@(loop for s in (cdr name-syms) collect `(add-hook ',s ',init-sym)))))

(defun forward-to-next-sexp ()
  (interactive)
  (up-list)
  (down-list))

(defun backward-to-previous-sexp ()
  (interactive)
  (backward-up-list)
  (backward-down-list))

(defun recenter-no-erase ()
  (interactive)
  (recenter '(4)))

(defun display-file (file)
  (let ((buff (get-file-buffer file)))
    (if buff
        (progn (set-buffer buff)
               (revert-buffer nil t)
               (display-buffer buff))
      (save-selected-window (find-file-other-window file)))))

(defun update-section-comment (c)
  (let* ((str (buffer-substring (line-beginning-position) (line-end-position)))
         (m (let ((s (char-to-string c)))
              (if (string-match (concat "^" s "* ?\\(.*?\\) ?" s "*$") str)
                  (match-string 1 str)
                "")))
         (p (point)))
    (delete-region (line-beginning-position) (line-end-position))
    (insert-char c 4)
    (if (string= m "") (insert " ")
      (insert " " m " ")
      (insert-char c (- 80 (current-column)))
      (goto-char (+ 5 (- p (match-beginning 1)))))))

(defun unfill-paragraph ()
  (interactive)
  (let ((fill-column (point-max)))
    (call-interactively 'fill-paragraph)))

(defun preserve-key-bindings (&rest keys)
  (add-to-list 'minor-mode-overriding-map-alist
               (cons t
                     (easy-mmode-define-keymap
                      (loop for x in keys collect
                            (let ((key (read-kbd-macro x)))
                              (cons key (key-binding key))))))))

;; http://stackoverflow.com/questions/384284/can-i-rename-an-open-file-in-emacs
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive
   (progn
     (if (not (buffer-file-name))
         (error "Buffer '%s' is not visiting a file!" (buffer-name)))
     (list (read-file-name (format "Rename %s to: " (file-name-nondirectory
                                                     (buffer-file-name)))))))
  (if (equal new-name "")
      (error "Aborted rename"))
  (setq new-name (if (file-directory-p new-name)
                     (expand-file-name (file-name-nondirectory
                                        (buffer-file-name))
                                       new-name)
                   (expand-file-name new-name)))
  ;; If the file isn't saved yet, skip the file rename, but still update the
  ;; buffer name and visited file.
  (if (file-exists-p (buffer-file-name))
      (rename-file (buffer-file-name) new-name 1))
  (let ((was-modified (buffer-modified-p)))
    ;; This also renames the buffer, and works with uniquify
    (set-visited-file-name new-name)
    (if was-modified
        (save-buffer)
      ;; Clear buffer-modified flag caused by set-visited-file-name
      (set-buffer-modified-p nil))
    (message "Renamed to %s." new-name)))
