#|
  This file is a part of schizoph project.
|#

(defsystem "schizoph-template-representer"
  :version "0.1.0"
  :author "carrotflakes"
  :license "LLGPL"
  :depends-on ("schizoph"
               "snaky")
  :components ((:module "src/representer"
                :components
                ((:file "template-representer"))))
  :description "template representer"
  ;:in-order-to ((test-op (test-op "schizoph-test")))
  )
