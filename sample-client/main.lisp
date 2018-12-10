(defpackage schizoph.sample-client
  (:use :cl
        :schizoph.sample-client.persona))
(in-package :schizoph.sample-client)


(defvar *app* (make-instance 'ningle:<app>))

(setf (ningle:route *app* "/" :method :GET :accept "text/html")
      "hello")

(setf (ningle:route *app* "/chat" :method :POST)
      #'(lambda (params)
          (let* ((params (lack.request:request-body-parameters ningle:*request*))
                 (text (cdr (assoc "text" params :test #'string=)))
                 (raw-context (cdr (assoc "context" params :test #'string=))))
            (if (stringp text)
                (multiple-value-bind (text next-context) (chat text raw-context)
                  (jojo:to-json `(:|state| "ok"
                                  :|text| ,text
                                  :|context| ,next-context)))
                (jojo:to-json `(:|state| "ng"
                                :|error| "text parameter is required!"))))))

(defparameter +static-path+
  (merge-pathnames "sample-client/static/"
                   (asdf:system-source-directory 'schizoph-sample-client)))

(setf *app*
      (funcall lack.middleware.static:*lack-middleware-static*
               (lack.component:to-app *app*)
               :path "/static/"
               :root +static-path+))

(clack:clackup *app*)
