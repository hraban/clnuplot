;;;-*- Mode: Lisp; Package: CLNUPLOT -*-

#| simple-header

Author: Gary King

DISCUSSION

|#
(in-package clnuplot)

(let ((plot
       (make-plot :bar
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