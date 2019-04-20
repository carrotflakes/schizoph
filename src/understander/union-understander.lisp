(defpackage schizoph.union-understander
  (:use :cl
        :schizoph.understander)
  (:import-from :schizoph.state
                :make-interpretation
                :interpretation-score)
  (:export :union-understander
           :make-union-understander))
(in-package :schizoph.union-understander)

(defclass union-understander (understander)
  ((understanders :initarg :understanders)))

(defun make-union-understander (understanders)
  (make-instance 'union-understander
                 :understanders understanders))

(defmethod understand ((understander union-understander) (input t) (state state))
  (loop
    for (child weight) in (slot-value understander 'understanders)
    for interpretations = (understand child input state)
    do (loop
         for interpretation in interpretations
         do (setf (interpretation-score interpretation)
                  (* (interpretation-score interpretation) weight)))
    append interpretations))
