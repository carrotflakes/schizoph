(defpackage schizoph.flagon-policy
  (:use :cl)
  (:import-from :schizoph.state
                :interpretation-intent
                :interpretation-entities
                :make-tactics
                :tactics-interpretation
                :tactics-intent)
  (:export :make-flagon-policy))
(in-package :schizoph.flagon-policy)

(defun flagon-construct (pattern state)
  (let ((bindings ()))
    (loop
      for (sign key . value) in pattern
      for variable = (flagon::variablep value)
      do (ecase sign
           (:plus
            (if variable
                (let ((pair (assoc variable state :test #'string=)))
                  (if pair
                      (push (cons key (cdr pair)) bindings)
                      (return-from flagon-construct (values nil nil))))
                (push (cons key value) bindings)))
           (:minus
            nil)))
    (values t bindings)))

;; pairs: ((interpretation-intent pattern tactics-intent tactics-entities updater score) ...)
(defun make-flagon-policy (pairs &optional default-state)
  (setf pairs (loop
                for (interpretation-intent
                     pattern
                     tactics-intent
                     tactics-entities
                     updater
                     score) in pairs
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
                                  updater)
                              (or score 1)))
        default-state (if (stringp default-state)
                          (flagon:state default-state)
                          default-state))

  (values
   (lambda (interpretation context state)
     (declare (ignore state))
     (loop
       for (interpretation-intent
            pattern
            tactics-intent
            tactics-entities-pattern
            updater
            score) in pairs
       when (equal interpretation-intent (interpretation-intent interpretation))
       append (multiple-value-bind (succ bindings)
                  (flagon:match pattern context)
                (when succ
                  (setf bindings (append bindings (interpretation-entities interpretation)))
                  (multiple-value-bind (succ tactics-entities)
                      (flagon-construct tactics-entities-pattern bindings)
                    (when succ
                      (list (make-tactics :interpretation interpretation
                                          :intent tactics-intent
                                          :entities tactics-entities
                                          :score score))))))))
   (lambda () default-state)
   (lambda (tactics context state)
     (declare (ignore state))
     (loop
       with interpretation = (tactics-interpretation tactics)
       for (interpretation-intent
            pattern
            tactics-intent
            tactics-entities-pattern
            updater
            score) in pairs
       when (and (equal interpretation-intent (interpretation-intent interpretation))
                 (equal tactics-intent (tactics-intent tactics)))
       do (multiple-value-bind (succ bindings)
              (flagon:match pattern context)
            (when succ
              (setf bindings (append bindings (interpretation-entities interpretation)))
              (return (flagon:update context
                                     updater
                                     bindings))))))))

(defun serialize (context)
  (jojo:to-json (cons :obj
                      (loop
                        for (key . value) in context
                        collect (cons (intern key :keyword) (or value :null))))
                :from :jsown))

(defun deserialize (string)
  (jojo:parse string))
