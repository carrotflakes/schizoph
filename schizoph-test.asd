#|
  This file is a part of schizoph project.
|#

(defsystem "schizoph-test"
  :defsystem-depends-on ("prove-asdf")
  :author "carrotflakes"
  :license "LLGPL"
  :depends-on ("schizoph"
               "schizoph-simple-understander"
               "schizoph-simple-policy"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "schizoph"))))
  :description "Test system for schizoph"

  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
