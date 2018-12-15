(defpackage schizoph
  (:use :cl
        :schizoph.state)
  (:import-from :schizoph.persona
                :make-persona
                :understander
                :policy
                :representer)
  (:import-from :schizoph.understander
                :understand)
  (:import-from :schizoph.policy
                :think
                :serialize
                :deserialize)
  (:export :make-persona
           :respond
           :serialize
           :deserialize))
(in-package :schizoph)


(defun interpret (state)
  (with-slots (persona intent-score-list input) state
    (with-slots (understander) persona
      (setf intent-score-list
            (loop
              with alist = (understand understander input state)
              for (intent . score) in (sort alist #'> :key #'cdr)
              collect (list intent score))))))

(defun plan (state)
  (with-slots (persona context intent-score-list intent-tactics-score-list) state
    (with-slots (policy) persona
      (setf intent-tactics-score-list
            (loop
              for (intent score-1) in intent-score-list
              for tactics-score-alist = (think policy intent context state)
              append (loop
                       for (tactics . score-2) in tactics-score-alist
                       collect (list intent tactics (* score-1 score-2)))))

      (setf intent-tactics-score-list
            (append intent-tactics-score-list
                    (loop
                       for (tactics . score) in (think policy :after context state)
                       collect (list :after tactics score))))

      (setf intent-tactics-score-list
            (sort intent-tactics-score-list #'> :key #'third))
      
      (when (null intent-tactics-score-list)
        (error "No tactics"))

      (setf (state-tactics state)
            (cadar intent-tactics-score-list)))))

(defun apply-tactics (state)
  (with-slots (persona intent tactics output context next-context) state
    (with-slots (policy representer) persona
      (setf output
            (funcall representer tactics state))
      (setf next-context
            (schizoph.policy:next-context policy intent context tactics state)))))


(defun respond (persona input context)
  (let ((state (make-state :persona persona
                           :context context
                           :input input)))
    (interpret state)
    (plan state)
    (apply-tactics state)

    (values (state-output state)
            (state-next-context state)
            state)))
