(ql:quickload '(:schizoph-template-representer))

(use-package :schizoph.template-representer)

(let ((represent (make-template-representer
                  `((:foo "foo!")
                    (:describe "my name is ${name}!")
                    (:bar ((:string "yo ") (:entity "name")))))))
  (print (funcall represent
                  (schizoph.state:make-tactics
                   :interpretation nil
                   :intent :foo
                   :entities '())
                  nil))
  (print (funcall represent
                  (schizoph.state:make-tactics
                   :interpretation nil
                   :intent :describe
                   :entities '(("name" . "borowski")))
                  nil))
  (print (funcall represent
                  (schizoph.state:make-tactics
                   :interpretation nil
                   :intent :bar
                   :entities '(("name" . "borowski")))
                  nil)))
