(in-package #:clnuplot)

(defparameter *gnuplot-home* "/usr/local/bin/gnuplot")

(defmethod write-plot ((plot gnuplot) (style (eql :pdf)))
  (write-plot plot :postscript)
  (execute-plot plot))

;;; ---------------------------------------------------------------------------
  
(defun execute-plot (plot) 
  (if (probe-file (fullpath plot))
    (ccl::do-shell-script
     (format nil "export PATH=/usr/local/bin:$PATH; cd ~A; ~A ~A"
             (macintosh-path->unix (make-pathname :type nil 
                                                  :name nil
                                                  :defaults (fullpath plot)))
             *gnuplot-home*
             (make-pathname :name (pathname-name (fullpath plot))
                            :type (pathname-type (fullpath plot)))))
    (error "Plot command file ~A does not exist" (fullpath plot))))

;;; ---------------------------------------------------------------------------

(defmethod open-plot-in-window (plot)
  (write-plot plot :pdf)
  (let ((pdf (make-pathname :type "pdf"
                            :defaults (fullpath plot))))
    (if (probe-file pdf)
      (ccl::open-image-window pdf))))
  
 