(defpackage schizoph.policy
  (:use :cl
        :schizoph.state)
  (:export :policy
           :context
           :make-context
           :think
           :next-context))
(in-package :schizoph.policy)

(defclass policy ())
(defclass context ())

(defgeneric make-context (policy))

(defgeneric think (policy t state))

(defgeneric next-context (policy t context state))
