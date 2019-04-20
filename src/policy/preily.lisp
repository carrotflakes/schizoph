(defpackage schizoph.preily
  (:use :cl
        :schizoph.policy
        :preil)
  (:import-from :schizoph.state
                :interpretation-intent
                :interpretation-entities
                :make-tactics)
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

(defmethod think ((policy preily) (interpretation t) (context t) (state state))
  ; entities is not supported yet
  (with-slots (world) policy
    (with-slots (ctx) context
      (let ((intent (interpretation-intent interpretation)))
        (with-world (world)
          (loop
            for (intent . score) = (solve-all (?intent . ?score)
                                              `(think ,intent ,ctx ?intent ?score))
            collect (make-tactics :interpretation interpretation
                                  :intent intent
                                  :entities '()
                                  :score score)))))))

(defmethod next-context ((policy preily)
                         (tactics t)
                         (context preily-context)
                         (state state))
  (with-slots (world) policy
    (with-slots (ctx) context
      (let* ((interpretation (tactics-interpretation tactics))
             (interpretation-intent (interpretation-intent interpretation))
             (tactics-intent (tactics-intent tactics))
             (next-ctx
              (with-world (world)
                (solve-1 ?ctx
                         `(next-context ,interpretation-intent ,ctx ,tactics-intent ?ctx)))))
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
