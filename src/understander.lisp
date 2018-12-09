(defpackage schizoph.understander
  (:use :cl
        :schizoph.state)
  (:export :understander
           :understand
           :state))
(in-package :schizoph.understander)

(defclass understander ()
  ())

(defgeneric understand (understander input state))
