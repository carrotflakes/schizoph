#|
  This file is a part of schizoph project.
|#

(defsystem "schizoph-invada"
  :version "0.1.0"
  :author "carrotflakes"
  :license "LLGPL"
  :depends-on ("schizoph-understander"
               "snaky"
               "optima")
  :components ((:module "src/understander/invada"
                :components
                ((:file "invada" :depends-on ("parser"))
                 (:file "parser"))))
  :description "invada understander"
  :in-order-to ((test-op (test-op "schizoph-invada-test"))))
