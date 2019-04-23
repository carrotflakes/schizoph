(defpackage schizoph.invada
  (:use :cl
        :schizoph.invada.parser)
  (:import-from :schizoph.state
                :make-interpretation)
  (:import-from :optima
                :ematch)
  (:export :make-invada-builder
           :add-macro
           :add-pattern
           :build))
(in-package :schizoph.invada)


(defstruct invada-builder
  macros
  patterns)

(defun add-macro (invada-builder macro-head body)
  (push (list (if (stringp macro-head)
                  (parse-macro-head macro-head)
                  macro-head)
              (if (stringp body)
                  (parse-body body)
                  body))
        (invada-builder-macros invada-builder)))

(defun add-pattern (invada-builder pattern score intent)
  (push (list (if (stringp pattern)
                  (parse-body pattern)
                  pattern)
              score
              intent)
        (invada-builder-patterns invada-builder)))

(defun body-prepare (body macros)
  (labels
      ((f (ast bindings)
         (ematch ast
           ((type string)
            ast)
           ((or :* :+ :nop)
            ast)
           ((list* :and tail)
            (list* :and (mapcar (lambda (ast) (f ast bindings)) tail)))
           ((list* :or tail)
            (list* :or (mapcar (lambda (ast) (f ast bindings)) tail)))
           ((list :bind ast name)
            (list :bind (f ast bindings) name))
           ((list* :macro-ref name args)
            (let ((prepared-args (mapcar (lambda (ast) (f ast bindings)) args)))
              (block resolve
                (dolist (macro macros)
                  (when (and (string= name (caar macro))
                             (= (length prepared-args) (length (cdar macro))))
                    (return-from resolve
                      (f (second macro)
                         (append (loop
                                   for arg in prepared-args
                                   for param in (cdar macro)
                                   collect (list (list param) arg))
                                 bindings)))))
                (error "not found: ~a" ast)))))))
    (f body macros)))

(defun parse (pattern string resolved)
  (loop
    with string-length = (length string)
    with branches = (list (list (list pattern) 0 '() '()))
    while branches
    for (thunk i bind-starts matched) = (pop branches)
    do (if (null thunk)
           (when (= i string-length)
             (funcall resolved matched))
           (let ((ast (pop thunk)))
             (ematch ast
               ((type string)
                (when (string= string ast
                               :start1 i
                               :end1 (min string-length (+ i (length ast))))
                  (push (list thunk (+ i (length ast)) bind-starts matched)
                        branches)))
               (:*
                (push (list thunk i bind-starts matched)
                      branches)
                (when (< i string-length)
                  (push (list (cons :* thunk) (1+ i) bind-starts matched)
                        branches)))
               (:+
                (when (< i string-length)
                  (push (list (cons :* thunk) (1+ i) bind-starts matched)
                        branches)))
               ((list* :and tail)
                (push (list (append tail thunk) i bind-starts matched)
                      branches))
               ((list* :or tail)
                (dolist (ast tail)
                  (push (list (cons ast thunk) i bind-starts matched)
                        branches)))
               ((list :bind ast name)
                (push (list (list* ast `(:bind-end ,name) thunk)
                            i
                            (cons i bind-starts)
                            matched)
                      branches))
               ((list :bind-end name)
                (push (list thunk
                            i
                            (cdr bind-starts)
                            (cons (cons name (subseq string (car bind-starts) i))
                                  matched))
                      branches))
               (:nop
                (push (list thunk i bind-starts matched)
                      branches)))))))

(defun build (invada-builder)
  (let* ((macros (invada-builder-macros invada-builder))
         (patterns
           (loop
             for (pattern score intent) in (invada-builder-patterns invada-builder)
             collect (list (body-prepare pattern macros)
                           score
                           intent))))
    (lambda (input state)
      (declare (ignore state))
      (loop
        with results = '()
        for (pattern score intent) in patterns
        do (parse pattern input
                  (lambda (matched)
                    (let ((score (etypecase score
                                   (number score)
                                   (function (funcall score matched)))))
                      (when (< 0 score)
                        (push (make-interpretation :intent intent
                                                   :entities matched
                                                   :score score)
                              results)))))
        finally (return results)))))
