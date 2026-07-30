;;; To make it easy to run scripts
;(defvar *script-exit-hooks* ())

;;; The following lines added by ql:add-to-init-file:
#-quicklisp
(let ((quicklisp-init (merge-pathnames ".quicklisp/setup.lisp"
                                       (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

;;;
;;; Load utility file
;;;
(load (merge-pathnames ".lisp-common" (user-homedir-pathname)))
