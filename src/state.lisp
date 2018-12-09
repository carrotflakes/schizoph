(defpackage schizoph.state
  (:use :cl
        :schizoph.persona
        :schizoph.understander
        :schizoph.policy
        :schizoph.representer)
  (:export :state
           :make-state
           :state-persona
           :state-input
           :state-intent-score-list
           :state-intent-tactics-score-list
           :state-ouput
           :state-context
           :state-next-context
           :interpret
           :plan
           :apply-tactics))
(in-package :schizoph.state)

(defstruct state
  persona
  input
  intent-score-list
  intent-tactics-score-list
  tactics
  output
  context
  next-context)

(defun interpret (state input)
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
  (with-slots (persona tactics output next-context) state
    (with-slots (policy representer) persona
      (setf output
            (represent representer tactics state))
      (setf next-context
            (next-context policy tactics state)))))
