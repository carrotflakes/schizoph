(defpackage schizoph.sample-client.persona
  (:use :cl
        :schizoph.simple-understander
        :schizoph)
  (:import-from :schizoph.simple-policy
                :make-simple-policy)
  (:export :make-context
           :persona
           :chat))
(in-package :schizoph.sample-client.persona)


(defvar understander
  (make-simple-understander
   '(("hello" hello () 1)
     ("goodbye" goodbye () 1))))

(defvar policy
  (make-simple-policy
   '((hello hello)
     (goodbye goodbye)
     (:default huh))))

(defvar representer
  #'schizoph.debug-representer:debug-representer)

(defvar persona
  (make-persona
   :understander understander
   :policy policy
   :representer representer))


(defun make-context ()
  (schizoph.simple-policy:make-context policy))

(defun chat (text raw-context)
  (let ((context (if raw-context
                     (deserialize policy raw-context)
                     (make-context))))
    (multiple-value-bind
          (response next-context state)
        (respond persona text context)
      (declare (ignore state))
      (values response (serialize next-context)))))
