#|
  This file is a part of schizoph project.
|#

(defsystem "schizoph-flagon-policy"
  :version "0.1.0"
  :author "carrotflakes"
  :license "LLGPL"
  :depends-on ("schizoph"
               "flagon"
               "jonathan")
  :components ((:module "src/policy"
                :components
                ((:file "flagon-policy"))))
  :description "policy using flagon"
  ;:in-order-to ((test-op (test-op "schizoph-test")))
  )
