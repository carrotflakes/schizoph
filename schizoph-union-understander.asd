#|
  This file is a part of schizoph project.
|#

(defsystem "schizoph-union-understander"
  :version "0.1.0"
  :author "carrotflakes"
  :license "LLGPL"
  :depends-on ("schizoph")
  :components ((:module "src/understander"
                :components
                ((:file "union-understander"))))
  :description "understanders bundler"
  ;:in-order-to ((test-op (test-op "schizoph-test")))
  )
