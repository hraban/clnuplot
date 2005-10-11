;;;-*- Mode: Lisp; Package: COMMON-LISP-USER -*-

#| simple-header

$Id: package.lisp,v 1.2 2005/06/03 13:57:14 gwking Exp $

Copyright 1992 - 2005 Experimental Knowledge Systems Lab, 
University of Massachusetts Amherst MA, 01003-4610
Professor Paul Cohen, Director

Author: Gary King

DISCUSSION

|#
(in-package :cl-user)


(eval-when (:compile-toplevel :load-toplevel :execute)
  (unless (find-package :clnuplot)
    (defpackage "CLNUPLOT"
      (:use "COMMON-LISP" "EKSL-UTILITIES")
      (:export #:open-plot-in-window)
    )))
