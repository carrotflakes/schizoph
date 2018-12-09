(defpackage schizoph
  (:use :cl
        :schizoph.persona
        :schizoph.state)
  (:export :make-persona
           :respond))
(in-package :schizoph)

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
