(defpackage schizoph.template-representer
  (:use :cl
        :snaky)
  (:import-from :schizoph.state
                :tactics-intent
                :tactics-entities)
  (:export :make-template-representer))
(in-package :schizoph.template-representer)

(define-condition template-representer-error (simple-error)
  ())

(defrule template
    (@ (* (or string-part
              entity-part))))

(defrule string-part
    (mod (@ (+ (or (cap (cc "^\\$"))
                   (and "\\" (cap (any))))))
         (lambda (chars)
           (list :string (apply #'concatenate 'string chars)))))

(defrule entity-part
    (and "${"
         (@ (and (ret :entity) (cap (+ (cc "^}")))))
         "}"))

(defparser parse-template template)

(defun parse-template* (template)
  (if (stringp template)
      (parse-template template)
      template))

(defun render (parsed-template entities)
  (apply #'concatenate
         'string
         (loop
           for (type value) in parsed-template
           collect (ecase type
                     (:entity
                      (or (cdr (assoc value entities :test #'equal))
                          (error 'template-representer-error
                                 :format-control "Entity ~a is missing"
                                 :format-arguments (list value))))
                     (:string
                      value)))))

;; pairs: ((intent template) ...)
(defun make-template-representer (pairs &optional (default-template "default"))
  (setf pairs
        (loop
          for (intent template) in pairs
          collect (cons intent (parse-template* template))))
  (let ((parsed-default-template (parse-template* default-template)))
    (lambda (tactics state
             &aux (intent (tactics-intent tactics)) (entities (tactics-entities tactics)))
      (declare (ignore state))
      (render (or (cdr (assoc intent pairs :test #'equal))
                  parsed-default-template)
              entities))))
