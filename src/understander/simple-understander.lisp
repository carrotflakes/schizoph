(defpackage schizoph.simple-understander
  (:use :cl
        :schizoph.understander)
  (:export :simple-understander
           :make-simple-understander))
(in-package :schizoph.simple-understander)

(defclass simple-understander (understander)
  ((pairs :initarg :pairs)))

(defun make-simple-understander (pairs)
  (make-instance 'simple-understander
                 :pairs pairs))

(defmethod understand ((understander simple-understander) (input t) (state state))
  (loop
    for (text intent) in (slot-value understander 'pairs)
    when (string= text input)
    collect (list intent 1)))
