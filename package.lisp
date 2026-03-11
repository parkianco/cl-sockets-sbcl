;;;; package.lisp
;;;; cl-sockets-sbcl package definition

(defpackage #:cl-sockets-sbcl
  (:use #:cl)
  (:nicknames #:sockets-sbcl)
  (:export
   ;; Socket creation/destruction
   #:make-socket
   #:socket-close
   ;; Client operations
   #:socket-connect
   #:socket-send
   #:socket-receive
   ;; Server operations
   #:socket-listen
   #:socket-accept
   ;; Utilities
   #:with-socket
   #:socket-stream
   ;; Conditions
   #:socket-error
   #:connection-refused-error
   #:connection-timeout-error))
