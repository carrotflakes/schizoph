(defpackage schizoph.echo
  (:use :cl
        :schizoph.policy)
  (:import-from :schizoph.state
                :interpretation-intent
                :interpretation-entities
                :make-tactics)
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

(defmethod think ((policy echo) (interpretation t) (context t) (state state))
  (list (make-tactics :interpretation interpretation
                      :intent (interpretation-intent interpretation)
                      :entities (interpretation-entities interpretation)
                      :score 1)))

(defmethod next-context ((policy echo)
                         (tactics t)
                         (context context)
                         (state state))
  context)
