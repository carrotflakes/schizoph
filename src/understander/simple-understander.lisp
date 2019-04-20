(defpackage schizoph.simple-understander
  (:use :cl
        :schizoph.understander)
  (:import-from :schizoph.state
                :make-interpretation)
  (:export :simple-understander
           :make-simple-understander))
(in-package :schizoph.simple-understander)

(defclass simple-understander (understander)
  ((pairs :initarg :pairs))) ; ((text intent entities score) ...)

(defun make-simple-understander (pairs)
  (make-instance 'simple-understander
                 :pairs pairs))

(defmethod understand ((understander simple-understander) (input t) (state state))
  (loop
    for (text intent entities score) in (slot-value understander 'pairs)
    when (string= text input)
    collect (make-interpretation :intent intent
                                 :entities entities
                                 :score score)))
