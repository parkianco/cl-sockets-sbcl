;;;; src/sockets.lisp
;;;; SBCL native socket implementation

(in-package #:cl-sockets-sbcl)

;;; Conditions

(define-condition socket-error (error)
  ((message :initarg :message :reader socket-error-message))
  (:report (lambda (c s)
             (format s "Socket error: ~A" (socket-error-message c)))))

(define-condition connection-refused-error (socket-error) ()
  (:report (lambda (c s)
             (declare (ignore c))
             (format s "Connection refused"))))

(define-condition connection-timeout-error (socket-error) ()
  (:report (lambda (c s)
             (declare (ignore c))
             (format s "Connection timed out"))))

;;; Socket creation

(defun make-socket (&key (type :stream) (protocol :tcp))
  "Create a new socket.
TYPE can be :STREAM (TCP) or :DATAGRAM (UDP).
PROTOCOL is :TCP or :UDP."
  (declare (ignore protocol))
  ;; sb-bsd-sockets:inet-socket accepts :stream/:datagram directly as :type
  (make-instance 'sb-bsd-sockets:inet-socket
                 :type type
                 :protocol :tcp))

(defun socket-close (socket)
  "Close SOCKET."
  (sb-bsd-sockets:socket-close socket))

;;; Client operations

(defun resolve-hostname (host)
  "Resolve HOST to an IP address vector."
  (etypecase host
    (string
     (if (every (lambda (c) (or (digit-char-p c) (char= c #\.))) host)
         ;; IP address string
         (let ((parts (loop for start = 0 then (1+ pos)
                            for pos = (position #\. host :start start)
                            collect (parse-integer host :start start :end pos)
                            while pos)))
           (coerce parts '(vector (unsigned-byte 8))))
         ;; Hostname - resolve it
         (let ((addr (sb-bsd-sockets:host-ent-address
                      (sb-bsd-sockets:get-host-by-name host))))
           addr)))
    (vector host)))

(defun socket-connect (host port &key (timeout nil))
  "Connect to HOST:PORT. Returns the connected socket."
  (declare (ignore timeout))
  (let ((socket (make-socket))
        (address (resolve-hostname host)))
    (handler-case
        (sb-bsd-sockets:socket-connect socket address port)
      (sb-bsd-sockets:connection-refused-error ()
        (error 'connection-refused-error :message "Connection refused")))
    socket))

(defun socket-send (socket data &key (encoding :utf-8))
  "Send DATA through SOCKET. DATA can be a string or byte vector."
  (let ((bytes (etypecase data
                 (string (sb-ext:string-to-octets data :external-format encoding))
                 ((vector (unsigned-byte 8)) data)
                 (vector (coerce data '(vector (unsigned-byte 8)))))))
    (sb-bsd-sockets:socket-send socket bytes (length bytes))))

(defun socket-receive (socket buffer-size &key (encoding :utf-8))
  "Receive up to BUFFER-SIZE bytes from SOCKET.
Returns (values data length) where data is a string if encoding is provided."
  (let ((buffer (make-array buffer-size :element-type '(unsigned-byte 8))))
    (multiple-value-bind (buf len)
        (sb-bsd-sockets:socket-receive socket buffer buffer-size)
      (declare (ignore buf))
      (if (and len (> len 0))
          (let ((result (subseq buffer 0 len)))
            (values (if encoding
                        (sb-ext:octets-to-string result :external-format encoding)
                        result)
                    len))
          (values nil 0)))))

;;; Server operations

(defun socket-listen (host port &key (backlog 5) (reuse-address t))
  "Create a listening socket on HOST:PORT."
  (let ((socket (make-socket))
        (address (resolve-hostname host)))
    (when reuse-address
      (setf (sb-bsd-sockets:sockopt-reuse-address socket) t))
    (sb-bsd-sockets:socket-bind socket address port)
    (sb-bsd-sockets:socket-listen socket backlog)
    socket))

(defun socket-accept (socket)
  "Accept a connection on listening SOCKET.
Returns the new client socket."
  (sb-bsd-sockets:socket-accept socket))

;;; Utilities

(defmacro with-socket ((var socket-form) &body body)
  "Execute BODY with VAR bound to SOCKET-FORM, ensuring socket is closed."
  `(let ((,var ,socket-form))
     (unwind-protect
          (progn ,@body)
       (when ,var
         (socket-close ,var)))))

(defun socket-stream (socket &key (element-type 'character) (external-format :utf-8))
  "Create a bidirectional stream from SOCKET."
  (sb-bsd-sockets:socket-make-stream socket
                                      :input t
                                      :output t
                                      :element-type element-type
                                      :external-format external-format
                                      :buffering :full))
