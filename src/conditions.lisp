;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;; SPDX-License-Identifier: Apache-2.0

(in-package #:cl-sockets-sbcl)

(define-condition cl-sockets-sbcl-error (error)
  ((message :initarg :message :reader cl-sockets-sbcl-error-message))
  (:report (lambda (condition stream)
             (format stream "cl-sockets-sbcl error: ~A" (cl-sockets-sbcl-error-message condition)))))
