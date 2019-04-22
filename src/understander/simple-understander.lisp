(defpackage schizoph.simple-understander
  (:use :cl)
  (:import-from :schizoph.state
                :make-interpretation)
  (:export :make-simple-understander))
(in-package :schizoph.simple-understander)

(defun make-simple-understander (pairs)
  (lambda (input state)
    (declare (ignore state))
    (loop
      for (text intent entities score) in pairs
      when (string= text input)
      collect (make-interpretation :intent intent
                                   :entities entities
                                   :score score))))
