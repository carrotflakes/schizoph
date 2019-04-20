(defpackage schizoph.ngram-understander
  (:use :cl
        :schizoph.understander)
  (:import-from :schizoph.state
                :make-interpretation)
  (:export :ngram-understander
           :make-ngram-understander))
(in-package :schizoph.ngram-understander)

(defclass ngram-understander (understander)
  ((pairs :initarg :pairs) ; ((text intent score) ...)
   (threshold :initarg :threshold :initform 0.0001)))

(defun make-ngram-understander (pairs &optional (threshold 0.0001))
  (make-instance 'ngram-understander
                 :pairs pairs
                 :threshold threshold))

(defun ngram (string n)
  (when (= n 1)
    (return-from ngram
      (loop
        for i from 0 below (length string)
        collect (subseq string i (1+ i)))))
  (loop
    with padded-string = (format nil "~{~a~}~a~{~a~}"
                                 (loop repeat (1- n) collect " ")
                                 string
                                 (loop repeat (1- n) collect " "))
    for i from 0 below (+ (length string) n -1)
    collect (subseq padded-string i (+ i n))))

(defun ngram-set (string max)
  (loop
    for n from 1 to max
    collect (ngram string n)))

(defun score (ngram-set1 ngram-set2)
  (/ (apply #'+
            (loop
              for set1 in ngram-set1
              for set2 in ngram-set2
              collect (/ (length (intersection set1 set2 :test #'string=))
                         (max (length (union set1 set2 :test #'string=)) 0))))
     (length ngram-set1)))

(defmethod understand ((understander ngram-understander) (input t) (state state))
  (loop
    with threshold = (slot-value understander 'threshold)
    with ngram-set = (ngram-set input 3)
    for (text intent base-score) in (slot-value understander 'pairs)
    for score = (* (score ngram-set (ngram-set text 3)) base-score)
    when (<= threshold score)
    collect (make-interpretation :intent intent
                                 :entities '()
                                 :score (float score))))
