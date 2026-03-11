;;;; cl-sockets-sbcl.asd
;;;; SBCL native socket wrapper with ZERO external dependencies

(asdf:defsystem #:cl-sockets-sbcl
  :description "SBCL native socket wrapper using sb-bsd-sockets"
  :author "Parkian Company LLC"
  :license "BSD-3-Clause"
  :version "1.0.0"
  :serial t
  :components ((:file "package")
               (:module "src"
                :components ((:file "sockets")))))
