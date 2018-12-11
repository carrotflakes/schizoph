(defpackage schizoph.state
  (:use :cl)
  (:export :state
           :make-state
           :persona
           :input
           :intent-score-list
           :intent-tactics-score-list
           :intent
           :tactics
           :output
           :context
           :next-context
           :state-persona
           :state-input
           :state-intent-score-list
           :state-intent-tactics-score-list
           :state-tactics
           :state-output
           :state-context
           :state-next-context))
(in-package :schizoph.state)

(defstruct state
  persona
  input
  intent-score-list
  intent-tactics-score-list
  intent
  tactics
  output
  context
  next-context)
