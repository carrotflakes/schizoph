#|
  This file is a part of schizoph project.
|#

(defsystem "schizoph-preily"
  :version "0.1.0"
  :author "carrotflakes"
  :license "LLGPL"
  :depends-on ("schizoph-policy"
               "preil")
  :components ((:module "src/policy"
                :components
                ((:file "preily"))))
  :description "policy using preil"
  ;:in-order-to ((test-op (test-op "schizoph-test")))
  )
