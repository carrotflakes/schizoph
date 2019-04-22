#|
  This file is a part of schizoph project.
|#

(defsystem "schizoph-serialize"
  :version "0.1.0"
  :author "carrotflakes"
  :license "LLGPL"
  :depends-on ()
  :components ((:module "src"
                :components
                ((:file "serialize"))))
  :description "schizoph context serialize and deserialize"
  ;:in-order-to ((test-op (test-op "schizoph-test")))
  )
