#|
  This file is a part of schizoph project.
|#

(defsystem "schizoph-simple-understander"
  :version "0.1.0"
  :author "carrotflakes"
  :license "LLGPL"
  :depends-on ("schizoph")
  :components ((:module "src/understander"
                :components
                ((:file "simple-understander"))))
  :description "simple understander"
  ;:in-order-to ((test-op (test-op "schizoph-test")))
  )
