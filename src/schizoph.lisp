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
  (with-slots (persona interpretations input) state
    (with-slots (understander) persona
      (setf interpretations
            (sort (understand understander input state) #'>
                  :key #'interpretation-score))))
  (values))

(defun plan (state)
  (with-slots (persona context interpretations tactics-list) state
    (with-slots (policy) persona
      (setf tactics-list
            (loop
              for interpretation in interpretations
              append (think policy interpretation context state)))

      (setf tactics-list
            (append tactics-list
                    (think policy
                           (make-interpretation :intent :default
                                                :entities '()
                                                :score 0)
                           context
                           state)))

      (setf tactics-list
            (sort tactics-list #'> :key #'tactics-combined-score))
      
      (when (null tactics-list)
        (error "No tactics"))

      (setf (state-tactics state) (first tactics-list)
            (state-interpretation state) (tactics-interpretation (first tactics-list))))))

(defun apply-tactics (state)
  (with-slots (persona interpretation tactics output context next-context) state
    (with-slots (policy representer) persona
      (setf output
            (funcall representer tactics state)
            next-context
            (schizoph.policy:next-context policy tactics context state)))))


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
