(ql:quickload '(:schizoph
                :schizoph-simple-understander
                :schizoph-flagon-policy
                :schizoph-debug-representer))

(use-package :schizoph)
(use-package :schizoph.simple-understander)
(use-package :schizoph.flagon-policy)

(defvar understander
  (make-simple-understander
   '(("hello" hello () 1)
     ("goodbye" goodbye () 1)
     ("I like cake" i-like (("food" . "cake")) 1)
     ("I like carrot" i-like (("food" . "carrot")) 1)
     ("What food I like?" tell-me-food-i-like () 1)
     ("Thanks" thanks () 1)
     ("goodbye" goodbye () 1))))

(defvar policy
  (make-flagon-policy
   '((hello "" hello "" "")
     (goodbye "" goodbye "" "")
     (i-like "" ok "" "foodUserLike:$food")
     (tell-me-food-i-like "foodUserLike:$food" food-you-like "food:$food" "")
     (tell-me-food-i-like "-foodUserLike" i-dont-know "" "")
     (thanks "" no-problem "" "")
     (:default "" default "" "+default"))
   "first"))

(defvar representer
  #'schizoph.debug-representer:debug-representer)

(defvar persona
  (make-persona
   :understander understander
   :policy policy
   :representer representer))

(defvar context (make-context policy))

(defun chat (text)
  (multiple-value-bind
        (response next-context state)
      (respond persona text context)
    (declare (ignore state))
    (format t "user: ~a~%" text)
    (format t "bot:  ~a~%" response)
    (setf context next-context)))

(chat "hello")
(chat "What food I like?")
(chat "I like cake")
(chat "What food I like?")
(chat "I like carrot")
(chat "What food I like?")
(chat "Thanks")
(chat "goodbye")
(chat "foobar")
