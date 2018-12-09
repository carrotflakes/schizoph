(defpackage schizoph.simple-policy
  (:use :cl
        :schizoph.policy)
  (:export :simple-policy
           :make-simple-policy
           :make-context))
(in-package :schizoph.simple-policy)

(defclass simple-policy (policy)
  ())
(defclass simple-context (context)
  ())

(defun make-simple-policy ()
  (make-instance 'simple-policy))

(defmethod make-context ((policy simple-policy))
  (make-instance 'simple-context))

(defmethod think ((policy simple-policy) (intent t) (state state))
  `((,intent 0.5)))

(defmethod next-context ((policy simple-policy)
                         (context simple-context)
                         (tactics t)
                         (state state))
  context)
