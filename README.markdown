# Schizoph

## Usage

``` lisp
(ql:quickload '(:schizoph
                :schizoph.foo-understander
                :schizoph.bar-policy
                :schizoph.baz-presenter))

(multiple-value-bind (think first-context next-context)
    (make-bar-policy ...)
  (defvar *first-context* first-context)
  (defvar *persona*
    (make-persona
       :understand (make-foo-understander ...)
       :think think
       :next-context next-context
       :represent (make-baz-representer ...))))

;; dialogue loop:
(loop
  with context = (funcall *first-context*)
  for text = (read-line)
  for (bot-text next-context state) = (multiple-value-list (respond *persona* text context))
  do (print bot-text)
     (setf context next-context))
```

## Installation
``` sh
$ ros install carrotflakes/schizoph
```

## Author

* carrotflakes (carrotflakes@gmail.com)

## Copyright

Copyright (c) 2018 carrotflakes (carrotflakes@gmail.com)

## License

Licensed under the LLGPL License.
