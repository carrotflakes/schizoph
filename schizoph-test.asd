#|
  This file is a part of schizoph project.
|#

(defsystem "schizoph-test"
  :defsystem-depends-on ("prove-asdf")
  :author ""
  :license "LLGPL"
  :depends-on ("schizoph"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "schizoph"))))
  :description "Test system for schizoph"

  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
