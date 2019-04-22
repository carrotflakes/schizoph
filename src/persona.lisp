(defpackage schizoph.persona
  (:use :cl)
  (:export :persona
           :make-persona
           :persona-p
           :understand
           :think
           :next-context
           :represent))
(in-package :schizoph.persona)

(defstruct persona
  understand
  think
  next-context
  represent)
