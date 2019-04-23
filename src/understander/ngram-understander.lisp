(defpackage schizoph.ngram-understander
  (:use :cl)
  (:import-from :schizoph.state
                :make-interpretation)
  (:export :make-ngram-understander))
(in-package :schizoph.ngram-understander)

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

;; paris: ((text intent entities score) ...)
(defun make-ngram-understander (pairs &optional (threshold 0.0001))
  (lambda (input state)
    (declare (ignore state))
    (loop
      with ngram-set = (ngram-set input 3)
      for (text intent entities base-score) in pairs
      for score = (* (score ngram-set (ngram-set text 3)) (or base-score 1))
      when (<= threshold score)
      collect (make-interpretation :intent intent
                                   :entities entities
                                   :score (float score)))))
