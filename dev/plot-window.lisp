(in-package #:clnuplot)

(defparameter *gnuplot-home* "/usr/local/bin/gnuplot")

(defmethod write-plot ((plot gnuplot) (style (eql :pdf)))
  (write-plot plot :postscript)
  (execute-plot plot))

(defun execute-plot (plot) 
  (if (probe-file (fullpath plot))
      (bind (((:values output error-output exit-status)
	      (trivial-shell:shell-command 
	       (format nil "export PATH=/usr/local/bin:$PATH; cd ~A; ~A ~A"
		       (make-pathname :type nil 
				      :name nil
				      :defaults (fullpath plot))
		       *gnuplot-home*
		       (pathname-name+type (fullpath plot))))))
	(unless (= (or exit-status 0) 0)
	  (error "Plot not created because ~a (exit code: ~a; output: ~a)"
		 error-output exit-status output)))
    (error "Plot command file ~A does not exist" (fullpath plot))))

#+digitool
(defmethod open-plot-in-window (plot)
  (write-plot plot :pdf)
  (let ((pdf (make-pathname :type "pdf"
                            :defaults (fullpath plot))))
    (if (probe-file pdf)
      (ccl::open-image-window pdf))))
  
 