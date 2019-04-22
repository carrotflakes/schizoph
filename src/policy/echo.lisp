(defpackage schizoph.echo
  (:use :cl)
  (:import-from :schizoph.state
                :interpretation-intent
                :interpretation-entities
                :make-tactics)
  (:export :make-echo))
(in-package :schizoph.echo)

(defun make-echo ()
  (values
   (lambda (interpretation context state)
     (declare (ignore context state))
     (list (make-tactics :interpretation interpretation
                         :intent (interpretation-intent interpretation)
                         :entities (interpretation-entities interpretation)
                         :score 1)))
   (lambda () '())
   (lambda (tactics context state)
     (declare (ignore tactics state))
     context)))
