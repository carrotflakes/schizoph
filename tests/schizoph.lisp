(defpackage schizoph-test
  (:use :cl
        :schizoph
        :schizoph.simple-understander
        :schizoph.simple-policy
        :prove))
(in-package :schizoph-test)

;; NOTE: To run this test file, execute `(asdf:test-system :schizoph)' in your Lisp.

(plan nil)

(defvar understander
  (make-simple-understander
   '(("hello" :hello () 1)
     ("goodbye" :goodbye () 1))))

(defvar policy
  (make-simple-policy
   '((:hello :hello)
     (:goodbye :goodbye)
     (:default :default))))

(defvar representer
  (lambda (tactics state)
    (declare (ignore state))
    (write-to-string tactics)))

(defvar persona
  (make-persona
   :understander understander
   :policy policy
   :representer representer))

(defvar context (make-context policy))

(defun chat (text)
  (multiple-value-bind
        (response next-context state)
      (respond persona text context)
    (declare (ignore state))
    (format t "~a~%" response)
    (setf context next-context)))

(chat "hello")
(chat "goodbye")
(chat "foobar")

(finalize)
