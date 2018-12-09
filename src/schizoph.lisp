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
                :think)
  (:export :make-persona
           :respond))
(in-package :schizoph)


(defun interpret (state)
  (with-slots (persona intent-score-list input) state
    (with-slots (understander) persona
      (setf intent-score-list (understand understander input state))
      (setf intent-score-list (sort intent-score-list #'> :key #'second)))))

(defun plan (state)
  (with-slots (persona intent-score-list intent-tactics-score-list) state
    (with-slots (policy) persona
      (setf intent-tactics-score-list
            (loop
              for (intent score-1) in intent-score-list
              for tactics-score-list = (think policy intent state)
              append (loop
                       for (tactics score-2) in tactics-score-list
                       collect (list intent tactics (* score-1 score-2)))))
      (setf intent-tactics-score-list
            (sort intent-tactics-score-list #'> :key #'third))

      ; TODO: metacognition
      (setf (state-tactics state)
            (cadar intent-tactics-score-list)))))

(defun apply-tactics (state)
  (with-slots (persona tactics output context next-context) state
    (with-slots (policy representer) persona
      (setf output
            (funcall representer tactics state))
      (setf next-context
            (schizoph.policy:next-context policy context tactics state)))))


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
