(defpackage schizoph.flagon-policy
  (:use :cl
        :schizoph.policy)
  (:import-from :schizoph.state
                :interpretation-intent
                :interpretation-entities
                :make-tactics
                :tactics-interpretation
                :tactics-intent)
  (:export :flagon-policy
           :make-flagon-policy
           :make-context))
(in-package :schizoph.flagon-policy)

(defclass flagon-policy (policy)
  ((pairs :initarg :pairs) ; ((interpretation-intent pattern tactics-intent tactics-entities updater) ...)
   (default-state :initarg :default-state)))
(defclass flagon-context (context)
  ((ctx :initarg :ctx)))

(defun make-flagon-policy (pairs &optional default-state)
  (make-instance 'flagon-policy
                 :pairs (loop
                          for (interpretation-intent
                               pattern
                               tactics-intent
                               tactics-entities
                               updater) in pairs
                          collect (list interpretation-intent
                                        (if (stringp pattern)
                                            (flagon:pattern pattern)
                                            pattern)
                                        tactics-intent
                                        (if (stringp tactics-entities)
                                            (flagon:pattern tactics-entities)
                                            tactics-entities)
                                        (if (stringp updater)
                                            (flagon:updater updater)
                                            updater)))
                 :default-state (if (stringp default-state)
                                    (flagon:state default-state)
                                    default-state)))

(defmethod make-context ((policy flagon-policy))
  (make-instance 'flagon-context :ctx (slot-value policy 'default-state)))

(defmethod think ((policy flagon-policy) (interpretation t) (context t) (state state))
  (loop
    with ctx = (slot-value context 'ctx)
    for (interpretation-intent
         pattern
         tactics-intent
         tactics-entities-pattern
         updater) in (slot-value policy 'pairs)
    when (equal interpretation-intent (interpretation-intent interpretation))
    append (multiple-value-bind (succ bindings)
               (flagon:match pattern ctx)
             (when succ
               (setf bindings (append bindings (interpretation-entities interpretation)))
               (multiple-value-bind (succ tactics-entities)
                   (flagon:match tactics-entities-pattern bindings)
                 (when succ
                   (list (make-tactics :interpretation interpretation
                                       :intent tactics-intent
                                       :entities tactics-entities
                                       :score 1))))))))

(defmethod next-context ((policy flagon-policy)
                         (tactics t)
                         (context flagon-context)
                         (state state))
  (loop
    with ctx = (slot-value context 'ctx)
    with interpretation = (tactics-interpretation tactics)
    for (interpretation-intent
         pattern
         tactics-intent
         tactics-entities-pattern
         updater) in (slot-value policy 'pairs)
    when (and (equal interpretation-intent (interpretation-intent interpretation))
              (equal tactics-intent (tactics-intent tactics)))
    do (multiple-value-bind (succ bindings)
           (flagon:match pattern ctx)
         (when succ
           (setf bindings (append bindings (interpretation-entities interpretation)))
           (return (make-instance 'flagon-context
                                  :ctx (flagon:update ctx
                                                      updater
                                                      bindings)))))))

(defmethod serialize ((context flagon-context))
  (jojo:to-json (cons :obj
                      (loop
                        for (key . value) in (slot-value context 'ctx)
                        collect (cons (intern key :keyword) (or value :null))))
                :from :jsown))

(defmethod deserialize ((policy flagon-policy) (string string))
  (make-instance 'flagon-context
                 :ctx (jojo:parse string)))
