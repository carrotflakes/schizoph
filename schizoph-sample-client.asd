(defsystem "schizoph-sample-client"
  :class :package-inferred-system
  :version "0.1.0"
  :author "carrotflakes"
  :license "LLGPL"
  :depends-on ("ningle"
               "lack-middleware-static"
               "clack"
               "jonathan"
               "schizoph-simple-understander"
               "schizoph-simple-policy"
               "schizoph")
  :components ((:module "sample-client"
                :components
                ((:file "main" :depends-on ("persona"))
                 (:file "persona"))))
  :description "schizoph sample client")
