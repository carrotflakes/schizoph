(defpackage schizoph.invada.parser
  (:use :cl
        :snaky)
  (:export :parse-macro-head
           :parse-body))
(in-package :schizoph.invada.parser)

(defrule macro-head 
    (@ (and str
            (? (and "("
                    ws
                    ident
                    (* (and ws "," ws ident))
                    ws
                    ")")))))

(defrule body
    (or %or
        (ret "")))

(defrule %or
    (or (@ (and (ret :or)
                (or %and (ret :nop))
                (+ (and ws "|" ws
                        (or %and (ret :nop))))))
        %and))

(defrule %and
    (or (@ (and (ret :and)
                bind
                (+ (and ws bind))))
        bind))

(defrule bind
    (or (@ (and (ret :bind)
                factor ws "@" ws ident))
        factor))

(defrule factor
    (or (and "(" ws %or ws ")")
        str
        %*
        %+
        macro-ref))

(defrule %*
    (and "*"
         (ret :*)))

(defrule %+
    (and "+"
         (ret :+)))

(defrule macro-ref
    (@ (and (ret :macro-ref)
            "$"
            ident
            (? (and "("
                    ws
                    body
                    (* (and ws "," ws body))
                    ws
                    ")")))))

(defrule ident
    (grp "ident"
         (cap (+ (and (! (or ws+ (cc "(),|$*+@")))
                      (any))))))

(defrule str
    (mod (@ (+ %char))
         (lambda (chars)
           (format nil "~{~a~}" chars))))

(defrule %char
    (or (and (! (or ws+ (cc "(),|$*+@")))
             (cap (any)))
        (and "\\"
             (cap (cc "(),|$*+@")))))

(defrule ws+
    (grp "whitespace"
         (+ (cc #.(format nil " ~a~a~a" #\cr #\lf #\tab)))))

(defrule ws
    (? ws+))


(defparser parse-macro-head macro-head)
(defparser parse-body body)
