;;;-*- Mode: Lisp; Package: COMMON-LISP-USER -*-

#| simple-header

Author: Gary King

DISCUSSION

|#

(in-package #:common-lisp-user)
(defpackage #:clnuplot-system (:use #:asdf #:cl))
(in-package #:clnuplot-system)

(defsystem clnuplot
  :version "0.2.2"
  :author "Gary Warren King <gwking@metabang.com>"
  :maintainer "Gary Warren King <gwking@metabang.com>"
  :licence "MIT License"
  :description "Common Lisp interface to GNUPlot."
  :components ((:module
		"dev"
		:components
		((:file "package")
		 (:file "utilities"
			:depends-on ("package"))
		 (:file "plots"
			:depends-on ("utilities"))
		 (:file "roc-curves"
			:depends-on ("plots"))     
		 (:file "plot-window"
			:depends-on ("plots"))
                         
		 (:static-file "notes.text")
		 (:static-file "examples"))))
  
  :depends-on (:cl-containers 
	       :cl-mathstats 
	       :metabang-bind
	       :trivial-shell))

