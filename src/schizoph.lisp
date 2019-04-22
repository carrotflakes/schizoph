(defpackage schizoph
  (:use :cl
        :schizoph.state)
  (:import-from :schizoph.persona
                :make-persona
                :understand
                :think
                :represent)
  (:export :make-persona
           :respond))
(in-package :schizoph)


(defun interpret (state)
  (with-slots (persona interpretations input) state
    (with-slots (understand) persona
      (setf interpretations
            (sort (funcall understand input state) #'>
                  :key #'interpretation-score))))
  (values))

(defun plan (state)
  (with-slots (persona context interpretations tactics-list) state
    (with-slots (think) persona
      (setf tactics-list
            (loop
              for interpretation in interpretations
              append (funcall think interpretation context state)))

      (setf tactics-list
            (append tactics-list
                    (funcall think (make-interpretation :intent :default
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
    (with-slots (represent) persona
      (setf output
            (funcall represent tactics state)
            next-context
            (funcall (slot-value persona 'schizoph.persona:next-context)
                     tactics context state)))))


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
