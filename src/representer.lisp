(defpackage schizoph.representer
  (:use :cl
        :schizoph.state)
  (:export :representer
           :represent))
(in-package :schizoph.representer)

(defclass representer ())

(defgeneric represent (representer t state))
