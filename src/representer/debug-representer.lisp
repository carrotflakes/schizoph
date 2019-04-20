(defpackage schizoph.debug-representer
  (:use :cl)
  (:import-from :schizoph.state
                :tactics-intent
                :tactics-entities)
  (:export :debug-representer))
(in-package :schizoph.debug-representer)

(defun debug-representer (tactics state)
  (declare (ignore state))
  (format nil "(~{~a~^ ~})" (cons (tactics-intent tactics) (tactics-entities tactics))))
