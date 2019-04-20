#|
  This file is a part of schizoph project.
|#

(defsystem "schizoph-debug-representer"
  :version "0.1.0"
  :author "carrotflakes"
  :license "LLGPL"
  :depends-on ("schizoph")
  :components ((:module "src/representer"
                :components
                ((:file "debug-representer"))))
  :description "representer for debug"
  ;:in-order-to ((test-op (test-op "schizoph-test")))
  )
