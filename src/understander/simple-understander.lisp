(defpackage schizoph.simple-understander
  (:use :cl
        :schizoph.understander)
  (:export :simple-understander
           :make-simple-understander))
(in-package :schizoph.simple-understander)

(defclass simple-understander (understander)
  ())

(defun make-simple-understander ()
  (make-instance 'simple-understander))

(defmethod understand ((understander simple-understander) (input t) (state state))
  '((hoge 1)))
