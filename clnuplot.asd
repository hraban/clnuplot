;;;-*- Mode: Lisp; Package: COMMON-LISP-USER -*-

#| simple-header

Author: Gary King

DISCUSSION

|#

(in-package :common-lisp-user)
(defpackage :clnuplot-system (:use #:asdf #:cl))
(in-package clnuplot-system)

;;; ---------------------------------------------------------------------------

#+Ignore
(glu-define-logical-pathname-translations (clnuplot)
  (source)
  (plots "plots")
  (metatilities (:back :back "metatilities" "dev"))
  (tests "tests"))

;;; ---------------------------------------------------------------------------

(defsystem clnuplot
  :version "0.1"
  :author "Gary Warren King <gwking@metabang.com>"
  :maintainer "Gary Warren King <gwking@metabang.com>"
  :licence "MIT License"
  :description "Common Lisp interface to GNUPlot."
  :components ((:module "dev"
                        :components
                        ((:file "package")
                         (:file "utilities"
                                :depends-on ("package"))
                         (:file "plots"
                                :depends-on ("utilities"))
                         (:file "roc-curves"
                                :depends-on ("plots"))     
                         
                         #+DIGITOOL
                         (:file "plot-window"
                                :depends-on ("plots"))
                         #-DIGITOOL
                         (:static-file "plot-window")
                         
                         (:static-file "notes")
                         (:static-file "examples"))))
  
  :depends-on (cl-containers cl-mathstats))


;;; ***************************************************************************
;;; *                              End of File                                *
;;; ***************************************************************************
