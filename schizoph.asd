#|
  This file is a part of schizoph project.
|#

(defsystem "schizoph"
  :version "0.1.0"
  :author ""
  :license "LLGPL"
  :depends-on ()
  :components ((:module "src"
                :components
                ((:file "schizoph"))))
  :description ""
  :long-description
  #.(read-file-string
     (subpathname *load-pathname* "README.markdown"))
  :in-order-to ((test-op (test-op "schizoph-test"))))
