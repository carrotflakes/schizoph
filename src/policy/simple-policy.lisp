(defpackage schizoph.simple-policy
  (:use :cl
        :schizoph.policy)
  (:export :simple-policy
           :make-simple-policy
           :make-context))
(in-package :schizoph.simple-policy)

(defclass simple-policy (policy)
  ((pairs :initarg :pairs)
   (default-tactics :initarg :default-tactics)))
(defclass simple-context (context)
  ())

(defun make-simple-policy (pairs default-tactics)
  (make-instance 'simple-policy
                 :pairs pairs
                 :default-tactics default-tactics))

(defmethod make-context ((policy simple-policy))
  (make-instance 'simple-context))

(defmethod think ((policy simple-policy) (intent t) (state state))
  (if (eq intent :after)
      `((,(slot-value policy 'default-tactics) 0.1))
      (loop
        for (intent* tactics) in (slot-value policy 'pairs)
        when (equal intent intent*)
        collect (list tactics 1))))

(defmethod next-context ((policy simple-policy)
                         (context simple-context)
                         (tactics t)
                         (state state))
  context)

(defmethod serialize ((context simple-context))
  "meaningless ;p")

(defmethod deserialize ((policy simple-policy) (string string))
  (make-context policy))
