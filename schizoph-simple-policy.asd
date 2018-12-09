#|
  This file is a part of schizoph project.
|#

(defsystem "schizoph-simple-policy"
  :version "0.1.0"
  :author "carrotflakes"
  :license "LLGPL"
  :depends-on ("schizoph-policy")
  :components ((:module "src/policy"
                :components
                ((:file "simple-policy"))))
  :description "simple policy"
  ;:in-order-to ((test-op (test-op "schizoph-test")))
  )
