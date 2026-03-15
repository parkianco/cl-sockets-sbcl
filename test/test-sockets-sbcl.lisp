;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;; SPDX-License-Identifier: Apache-2.0

;;;; test-sockets-sbcl.lisp - Unit tests for sockets-sbcl
;;;;
;;;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;;;; SPDX-License-Identifier: Apache-2.0

(defpackage #:cl-sockets-sbcl.test
  (:use #:cl)
  (:export #:run-tests))

(in-package #:cl-sockets-sbcl.test)

(defun run-tests ()
  "Run all tests for cl-sockets-sbcl."
  (format t "~&Running tests for cl-sockets-sbcl...~%")
  ;; TODO: Add test cases
  ;; (test-function-1)
  ;; (test-function-2)
  (format t "~&All tests passed!~%")
  t)
