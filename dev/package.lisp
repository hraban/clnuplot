;;;-*- Mode: Lisp; Package: COMMON-LISP-USER -*-

#| simple-header

Author: Gary King

DISCUSSION

|#
(in-package #:cl-user)

(defpackage #:clnuplot
  (:use #:common-lisp #:metatilities #:bind 
	#:cl-mathstats #:cl-containers)
  (:import-from #:metatilities
		#:pathname-name+type )   
  (:export
   #:make-plot
   #:write-plot
   #:fullpath
          
   #:scatter-plot
   #:histogram

   #:roc!
   #:roc 
   #:make-roc-plot 
   #:make-roc-plot-template
          
   #:*plot-default-host*
   #:*plot-default-directory*
   #:*plot-ps2pdf-directory*
   #:*gnuplot-home*)
  #+ccl
  (:export #:open-plot-in-window))



