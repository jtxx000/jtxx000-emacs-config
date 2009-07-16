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
  (newline-and-indent))

(defun newline-over ()
  (interactive)
  (beginning-of-line)
  (split-line)
  (indent-according-to-mode))

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
