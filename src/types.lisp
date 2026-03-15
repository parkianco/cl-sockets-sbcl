;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;; SPDX-License-Identifier: Apache-2.0

(in-package #:cl-sockets-sbcl)

;;; Core types for cl-sockets-sbcl
(deftype cl-sockets-sbcl-id () '(unsigned-byte 64))
(deftype cl-sockets-sbcl-status () '(member :ready :active :error :shutdown))
