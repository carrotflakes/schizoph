(defpackage schizoph.union-understander
  (:use :cl)
  (:import-from :schizoph.state
                :make-interpretation
                :interpretation-score)
  (:export :make-union-understander))
(in-package :schizoph.union-understander)

(defun make-union-understander (understanders)
  (lambda (input state)
    (loop
      for (child weight) in understanders
      for interpretations = (funcall child input state)
      do (loop
           for interpretation in interpretations
           do (setf (interpretation-score interpretation)
                    (* (interpretation-score interpretation) weight)))
      append interpretations)))
