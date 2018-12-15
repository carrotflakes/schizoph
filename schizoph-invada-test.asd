#|
  This file is a part of schizoph project.
|#

(defsystem "schizoph-invada-test"
  :defsystem-depends-on ("prove-asdf")
  :author "carrotflakes"
  :license "LLGPL"
  :depends-on ("schizoph-invada"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "schizoph-invada"))))
  :description "Test system for schizoph-invada"

  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
