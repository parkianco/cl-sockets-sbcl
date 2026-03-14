;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;; SPDX-License-Identifier: BSD-3-Clause

;;;; cl-sockets-sbcl.asd
;;;; SBCL native socket wrapper with ZERO external dependencies

(asdf:defsystem #:cl-sockets-sbcl
  :description "SBCL native socket wrapper using sb-bsd-sockets"
  :author "Parkian Company LLC"
  :license "BSD-3-Clause"
  :version "0.1.0"
  :serial t
  :components ((:file "package")
               (:module "src"
                :components ((:file "sockets")))))

(asdf:defsystem #:cl-sockets-sbcl/test
  :description "Tests for cl-sockets-sbcl"
  :depends-on (#:cl-sockets-sbcl)
  :serial t
  :components ((:module "test"
                :components ((:file "test-sockets-sbcl"))))
  :perform (asdf:test-op (o c)
             (let ((result (uiop:symbol-call :cl-sockets-sbcl.test :run-tests)))
               (unless result
                 (error "Tests failed")))))
