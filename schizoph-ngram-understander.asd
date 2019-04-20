#|
  This file is a part of schizoph project.
|#

(defsystem "schizoph-ngram-understander"
  :version "0.1.0"
  :author "carrotflakes"
  :license "LLGPL"
  :depends-on ("schizoph-understander")
  :components ((:module "src/understander"
                :components
                ((:file "ngram-understander"))))
  :description "ngram understander"
  ;:in-order-to ((test-op (test-op "schizoph-test")))
  )
