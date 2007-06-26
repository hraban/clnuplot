;;;-*- Mode: Lisp; Package: CLNUPLOT -*-

#| simple-header

Author: Gary King

DISCUSSION

|#
(in-package #:clnuplot)

#+(or)
;; FIXME - requires cl-variates
(let ((plot
       (make-plot 
	:bar
	(element-counts
	 (loop repeat 100 collect (poisson-random *random-generator* 5))
	 :sort-on :values
	 :sort #'<)
	:filename "poisson-mean-5"
	:title "Poisson Distributions"
	:legend "Mean 5"
	:fill (list :solid 0.25)
	:xmin -1)))
  (make-plot :bar
             (element-counts
              (loop repeat 50 collect (poisson-random *random-generator* 10))
              :sort-on :values
              :sort #'<)
             :legend "Mean 10"
             :fill (list :solid 0.25)
             :plot plot))

(let ((plot
       (make-plot 
	:bar
	(element-counts
	 (loop repeat 100 collect (random 10))
	 :sort-on :values
	 :sort #'<)
	:filename "clnuplot-example-1"
	:title "Common Lisp Random"
	:legend "Mean"
	:fill (list :solid 0.25)
	:xmin -1)))
  (make-plot :bar
             '((0 1) (1 3) (2 6) (3 4) (4 4) (5 1) (6 0.5) (7 0.25) 
	       (8 1) (9 3) (10 8))
             :legend "Some points"
             :fill (list :solid 0.25)
             :plot plot)
  (write-plot plot :postscript))