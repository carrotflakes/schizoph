(defpackage schizoph.persona
  (:use :cl)
  (:export :persona
           :make-persona
           :persona-p
           :understander
           :policy
           :representer))
(in-package :schizoph.persona)

(defstruct persona
  understander
  policy
  representer)
