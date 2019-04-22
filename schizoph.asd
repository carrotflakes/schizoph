#|
  This file is a part of schizoph project.
|#

(defsystem "schizoph"
  :version "0.1.0"
  :author "carrotflakes"
  :license "LLGPL"
  :depends-on ()
  :components ((:module "src"
                :components
                ((:file "schizoph" :depends-on ("persona" "state"))
                 (:file "state")
                 (:file "persona"))))
  :description "*Vessel of the soul*"
  :long-description
  #.(read-file-string
     (subpathname *load-pathname* "README.markdown"))
  :in-order-to ((test-op (test-op "schizoph-test"))))
