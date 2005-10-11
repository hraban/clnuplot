;; Should not need to specify the x-coord and y-coord in each sub-plot
(open-plot-in-window
 (let ((plot 
        (make-plot nil nil
                   :xlabel "Iteration"
                   :ylabel "Count of Hats nearly classified as terrorist"
                   :title "Iteration vs. Classification Counts")))
   (make-plot :lines-points
              '(7   5  14  43  67  47 115 284 385  63   1   1   0)
              :legend "Best separation"
              :x-coord nil
              :y-coord #'identity
              :plot plot)
   (make-plot :lines-points
              '(8  16  49  70 103 230 458  98   2   0)
              :legend "Poor separation"
              :x-coord nil
              :y-coord #'identity
              :plot plot)))

;; Also be nice to do above as 
(open-plot-in-window
 (make-plot :lines-points 
            '((7   5  14  43  67  47 115 284 385  63   1   1   0)
              (8  16  49  70 103 230 458  98   2   0))
            :legends '("Best separation"
                       "Poor separation")
            :xlabel "Iteration"
            :ylabel "Count of Hats nearly classified as terrorist"
            :x-coord nil
            :y-coord #'identity
            :title "Iteration vs. Classification Counts"))


sorted-list-container was f*ing ROC curves
list-container means values end up in wrong order!

automatically offset multiple bar graphs...

#+Test
(ccl::do-shell-script
 "/usr/local/bin/gnuplot ~/repository/p2dis/clnuplot/dev/plots/20050524-roc-p-4-4000.data")

(ccl::do-shell-script
 (format nil "/usr/local/bin/gnuplot ~A" 
         (macintosh-path->unix #P"clnuplot:plots;20050524-roc-p-4-4000.data")))

labeling points

multiple roc curves

Support for parameter verification (e.g., boxes fill can be solid, pattern or empty)

Support for optional parameters (e.g., boxes fill solid takes an optional density
                                       argument from 0 to 1)

adding text / extra notes to a plot


ok - making it square (for roc)
ok - hiding legend
