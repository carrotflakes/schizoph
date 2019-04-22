(defpackage schizoph.sample-client.persona
  (:use :cl
        :schizoph.simple-understander
        :schizoph
        :schizoph.serialize)
  (:import-from :schizoph.simple-policy
                :make-simple-policy)
  (:export :make-context
           :persona
           :chat))
(in-package :schizoph.sample-client.persona)


(defvar understand
  (make-simple-understander
   '(("hello" hello () 1)
     ("goodbye" goodbye () 1))))

(multiple-value-bind (think first-context next-context)
  (make-simple-policy
   '((hello hello)
     (goodbye goodbye)
     (:default huh)))
  (defvar think think)
  (defvar first-context first-context)
  (defvar next-context next-context))

(defvar represent
  schizoph.debug-representer:debug-representer)

(defvar persona
  (make-persona
   :understand understand
   :think think
   :next-context next-context
   :represent represent))


(defun make-context ()
  (funcall first-context))

(defun chat (text raw-context)
  (let ((context (if raw-context
                     (deserialize raw-context)
                     (make-context))))
    (multiple-value-bind
          (response next-context state)
        (respond persona text context)
      (declare (ignore state))
      (values response (serialize next-context)))))
