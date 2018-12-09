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
           :state))
(in-package :schizoph.policy)

(defclass policy ()
  ())
(defclass context ()
  ())

(defgeneric make-context (policy))

(defgeneric think (policy intent state))

(defgeneric next-context (policy context tactics state))

(defgeneric serialize (context))

(defgeneric deserialize (policy string))
