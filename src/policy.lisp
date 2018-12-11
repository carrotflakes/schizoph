(defpackage schizoph.policy
  (:use :cl
        :schizoph.state)
  (:export :policy
           :context
           :make-context
           :think
           :next-context
           :serialize
           :deserialize
           :state
           :safe-read-from-string))
(in-package :schizoph.policy)

(defclass policy ()
  ())
(defclass context ()
  ())

(defgeneric make-context (policy))

(defgeneric think (policy intent context state))

(defgeneric next-context (policy context tactics state))

(defgeneric serialize (context))

(defgeneric deserialize (policy string))


(defvar safe-read-from-string-blacklist
  '(#\# #\: #\|))

(let ((rt (copy-readtable nil)))
  (defun safe-reader-error (stream closech)
    (declare (ignore stream closech))
    (error "safe-read-from-string failure"))

  (dolist (c safe-read-from-string-blacklist)
    (set-macro-character
     c #'safe-reader-error nil rt))

  (defun safe-read-from-string (s &optional fail)
    (if (stringp s)
        (let ((*readtable* rt) *read-eval*)
          (handler-bind
              ((error (lambda (condition)
                        (declare (ignore condition))
                        (return-from
                         safe-read-from-string fail))))
            (read-from-string s)))
        fail)))
