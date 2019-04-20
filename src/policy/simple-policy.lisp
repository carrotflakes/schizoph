(defpackage schizoph.simple-policy
  (:use :cl
        :schizoph.policy)
  (:import-from :schizoph.state
                :interpretation-intent
                :interpretation-entities
                :make-tactics)
  (:export :simple-policy
           :make-simple-policy
           :make-context))
(in-package :schizoph.simple-policy)

(defclass simple-policy (policy)
  ((pairs :initarg :pairs)))
(defclass simple-context (context)
  ())

(defun make-simple-policy (pairs)
  (make-instance 'simple-policy
                 :pairs pairs))

(defmethod make-context ((policy simple-policy))
  (make-instance 'simple-context))

(defmethod think ((policy simple-policy) (interpretation t) (context t) (state state))
  (loop
    with intent = (interpretation-intent interpretation)
    for (intent* tactics-intent) in (slot-value policy 'pairs)
    when (equal intent intent*)
    collect (make-tactics :interpretation interpretation
                          :intent intent*
                          :entities (interpretation-entities interpretation)
                          :score 1)))

(defmethod next-context ((policy simple-policy)
                         (tactics t)
                         (context simple-context)
                         (state state))
  context)

(defmethod serialize ((context simple-context))
  "meaningless ;p")

(defmethod deserialize ((policy simple-policy) (string string))
  (make-context policy))
