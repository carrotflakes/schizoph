(defpackage schizoph.state
  (:use :cl)
  (:export :interpretation
           :make-interpretation
           :intent
           :entities
           :score
           :interpretation-intent
           :interpretation-entities
           :interpretation-score
           :tactics
           :make-tactics
           :tactics-interpretation
           :tactics-intent
           :tactics-entities
           :tactics-score
           :tactics-combined-score
           :state
           :make-state
           :persona
           :input
           :interpretations
           :tactics-list
           :tactics
           :output
           :context
           :next-context
           :state-persona
           :state-input
           :state-interpretations
           :state-tactics-list
           :state-interpretation
           :state-tactics
           :state-output
           :state-context
           :state-next-context))
(in-package :schizoph.state)

(defstruct interpretation
  intent
  entities
  score)

(defstruct tactics
  interpretation
  intent
  entities
  score)

(defun tactics-combined-score (tactics)
  (* (interpretation-score (tactics-interpretation tactics))
     (tactics-score tactics)))

(defstruct state
  persona
  input
  interpretations
  tactics-list
  interpretation
  tactics
  output
  context
  next-context)
