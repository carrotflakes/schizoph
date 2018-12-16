(defpackage schizoph.preily
  (:use :cl
        :schizoph.policy
        :preil)
  (:export :preily
           :make-preily
           :make-context
           :initial-context
           :think
           :next-context))
(in-package :schizoph.preily)

(defclass preily (policy)
  ((world :initarg :world)))
(defclass preily-context (context)
  ((ctx :initarg :ctx)))

(defun make-preily (world)
  (make-instance 'preily
                 :world world))

(defmethod make-context ((policy preily))
  (with-slots (world) policy
    (make-instance 'preily-context
                   :ctx (with-world (world)
                          (solve-1 ?ctx
                                   '(initial-context ?ctx))))))

(defmethod think ((policy preily) (intent t) (context t) (state state))
  (with-slots (world) policy
    (with-slots (ctx) context
      (with-world (world)
        (solve-all (?tactics . ?score)
                   `(think ,intent ,ctx ?tactics ?score))))))

(defmethod next-context ((policy preily)
                         (intent t)
                         (context preily-context)
                         (tactics t)
                         (state state))
  (with-slots (world) policy
    (with-slots (ctx) context
      (let ((next-ctx
              (with-world (world)
                (solve-1 ?ctx
                         `(next-context ,intent ,ctx ,tactics ?ctx)))))
        (unless next-ctx
          (error "solve next-context failed"))
        (make-instance 'preily-context
                       :ctx  next-ctx)))))

(defmethod serialize ((context preily-context))
  (with-slots (ctx) context
    (write-to-string ctx)))

(defmethod deserialize ((policy preily) (string string))
  (let ((ctx (safe-read-from-string string)))
    (make-instance 'preily-context
                   :ctx ctx)))
