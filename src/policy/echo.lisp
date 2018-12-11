(defpackage schizoph.echo
  (:use :cl
        :schizoph.policy)
  (:export :echo
           :make-echo
           :make-context))
(in-package :schizoph.echo)

(defclass echo (policy)
  ())

(defun make-echo ()
  (make-instance 'echo))

(defmethod make-context ((policy echo))
  (make-instance 'context))

(defmethod think ((policy echo) (intent t) (context t) (state state))
  `((intent 1)))

(defmethod next-context ((policy echo)
                         (context context)
                         (tactics t)
                         (state state))
  context)
