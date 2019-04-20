(defpackage schizoph-invada-test
  (:use :cl
        :schizoph.invada
        :prove))
(in-package :schizoph-invada-test)

;; NOTE: To run this test file, execute `(asdf:test-system :schizoph-invada)' in your Lisp.

(plan nil)

(defun f (s)
  (print s)
  (print (handler-case (schizoph.invada.parser::parse-body s)
           (error (c)
             c))))

(f "")
(f "a")
(f "hello")
(f "a | b")
(f "a b")
(f "a b (c|d)")
(f "*")
(f "*@name")
(f "$hoge")
(f "$hoge $fuga $piyo(foo, bar)@yo")


(defvar builder (make-invada-builder))

(add-pattern builder
             "こんにち(は|わ)"
             1
             'greeting)

(add-pattern builder
             "$果物@fruit が好きです"
             1
             '(like fruit))

(add-pattern builder
             "* $果物@fruit *"
             0.5
             '(keyword fruit))

(add-macro builder
           "果物"
           '(:or "りんご" "みかん" "ぶどう"))

(defvar invada (build builder))

(print (schizoph.understander:understand
        invada
        "りんごが好きです"
        (schizoph.state::make-state)))

(finalize)
