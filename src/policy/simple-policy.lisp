(defpackage schizoph.simple-policy
  (:use :cl)
  (:import-from :schizoph.state
                :interpretation-intent
                :interpretation-entities
                :make-tactics)
  (:export :make-simple-policy))
(in-package :schizoph.simple-policy)

(defun make-simple-policy (pairs)
  (values
   (lambda (interpretation context state)
     (declare (ignore context state))
     (loop
       with intent = (interpretation-intent interpretation)
       for (intent* tactics-intent) in pairs
       when (equal intent intent*)
       collect (make-tactics :interpretation interpretation
                             :intent intent*
                             :entities (interpretation-entities interpretation)
                             :score 1)))
   (lambda () '())
   (lambda (tactics context state)
     (declare (ignore tactics state))
     context)))
