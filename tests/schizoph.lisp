(defpackage schizoph-test
  (:use :cl
        :schizoph
        :schizoph.simple-understander
        :schizoph.simple-policy
        :prove))
(in-package :schizoph-test)

;; NOTE: To run this test file, execute `(asdf:test-system :schizoph)' in your Lisp.

(plan nil)

(defvar understand
  (make-simple-understander
   '(("hello" :hello () 1)
     ("goodbye" :goodbye () 1))))

(multiple-value-bind (think first-context next-context)
    (make-simple-policy
     '((:hello :hello)
       (:goodbye :goodbye)
       (:default :default)))
  (defvar think think)
  (defvar first-context first-context)
  (defvar next-context next-context))

(defvar represent
  (lambda (tactics state)
    (declare (ignore state))
    (write-to-string tactics)))

(defvar persona
  (make-persona
   :understand understand
   :think think
   :next-context next-context
   :represent represent))

(defvar context (funcall first-context))

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
