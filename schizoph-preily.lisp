#|
  This file is a part of schizoph project.
|#

(defsystem "schizoph-preily"
  :version "0.1.0"
  :author "carrotflakes"
  :license "LLGPL"
  :depends-on ("schizoph-policy")
  :components ((:module "src/policy"
                :components
                ((:file "preily"))))
  :description "simple policy"
  ;:in-order-to ((test-op (test-op "schizoph-test")))
  )
