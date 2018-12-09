#|
  This file is a part of schizoph project.
|#

(defsystem "schizoph-understander"
  :version "0.1.0"
  :author "carrotflakes"
  :license "LLGPL"
  :depends-on ()
  :components ((:module "src"
                :components
                ((:file "understander" :depends-on ("state"))
                 (:file "state" :depends-on ("persona"))
                 (:file "persona"))))
  :description "understander superclass"
  ;:in-order-to ((test-op (test-op "schizoph-test")))
  )
