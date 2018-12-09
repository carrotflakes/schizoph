(defpackage schizoph-test
  (:use :cl
        :schizoph
        :schizoph.simple-understander
        :schizoph.simple-policy
        :prove))
(in-package :schizoph-test)

;; NOTE: To run this test file, execute `(asdf:test-system :schizoph)' in your Lisp.

(plan nil)

(defvar understander (make-simple-understander))
(defvar policy (make-simple-policy))
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

(multiple-value-bind
      (response next-context state)
    (respond persona "hello" context)
    (declare (ignore next-context state))
  (format t "~a~%" response))

(finalize)
