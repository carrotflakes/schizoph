(defpackage schizoph.understander
  (:use :cl
        :schizoph.state)
  (:export :understander
           :understand))
(in-package :schizoph.understander)

(defclass understander ())

(defgeneric understand (understander t state))
