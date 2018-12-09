#|
  This file is a part of schizoph project.
|#

(defsystem "schizoph-representer"
  :version "0.1.0"
  :author "carrotflakes"
  :license "LLGPL"
  :depends-on ()
  :components ((:module "src"
                :components
                ((:file "representer" :depends-on ("state"))
                 (:file "state" :depends-on ("persona"))
                 (:file "persona"))))
  :description "representer superclass"
  ;:in-order-to ((test-op (test-op "schizoph-test")))
  )
