#|
  This file is a part of schizoph project.
|#

(defsystem "schizoph-policy"
  :version "0.1.0"
  :author "carrotflakes"
  :license "LLGPL"
  :depends-on ()
  :components ((:module "src"
                :components
                ((:file "policy" :depends-on ("state"))
                 (:file "state" :depends-on ("persona"))
                 (:file "persona"))))
  :description "policy superclass"
  ;:in-order-to ((test-op (test-op "schizoph-test")))
  )
