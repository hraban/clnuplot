;;;-*- Mode: Lisp; Package: COMMON-LISP-USER -*-

#| simple-header

Author: Gary King

DISCUSSION

|#
(in-package :cl-user)


(eval-when (:compile-toplevel :load-toplevel :execute)
  (unless (find-package '#:clnuplot)
    (defpackage #:clnuplot
      (:use #:common-lisp #:metatilities #:bind #:cl-mathstats)
      (:export
       #:make-plot
       #:write-plot
       #:fullpath
          
       #:scatter-plot
       #:histogram
          
       #:*plot-default-host*
       #:*plot-default-directory*
       #:*plot-ps2pdf-directory*)
      (:export #:open-plot-in-window))))
