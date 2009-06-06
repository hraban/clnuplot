(in-package #:clnuplot)

(write-plot
 (clnuplot:make-plot
  :bar
  '((1 2 "a") (2 2.5 "b") (3 3.1 "c"))
  :linewidth 3.0
  :key "off"
  :filename "bar12"
  :xlabel "Bin Number"
  :ylabel "Dance Partners"
  :x-coord #'first
  :y-coord #'second
  :title "Bin Number versus Dance Partners"
  :ymin 0.0) :postscript)
