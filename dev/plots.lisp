#| simple-header

Author: Gary King

DISCUSSION

|#
(in-package #:clnuplot)

#|
write-plot-settings has too much similarity
make-data-set has too much similarity
|#

(defvar *plot-default-host* "clnuplot")
(defvar *plot-default-directory* "plots")
(defvar *plot-ps2pdf-directory* "/usr/local/bin/")

(defparameter *plot-plot-settings* 
  `((:title)
    (:xlabel)
    (:ylabel)
    (:xmin :range)
    (:ymin :range)
    (:xmax :range)
    (:ymax :range)
    (:key)
    (:border)
    (:grid)
    (:size)))

#|
set key {on|off} {default}
  {left | right | top | bottom | outside | below | <position>}
  {Left | Right} {{no}reverse}
  {samplen <sample_length>} {spacing <vertical_spacing>}
  {width <width_increment>}
  {height <height_increment>}
  {{no}autotitles}
  {title "<text>"} {{no}enhanced}
  {{no}box { {linestyle | ls <line_style>}
  | {linetype | lt <line_type>}
  {linewidth | lw <line_width>}}}
|#

(defparameter *plot-data-set-settings*
  `((:style)
    (:legend :translate :title)
    (:fill)
    (:linewidth :translate :linewidth)
    (:linetype)
    (:linestyle)
    (:pointsize)))

(defclass* plot-abstract ()
  ((settings (make-container 'simple-associative-container) r)
   (data-sets (make-container 'stable-associative-container) r)
   (comment nil ia)))

(defgeneric write-plot (plot style)
  (:documentation "")
  (:method :around ((plot t) (style t))
           ;; ensure return value is the plot
           (call-next-method)
           (values plot)))


(defun fullpath (plot)
  ;; FIXME
  (asdf:system-relative-pathname 
   (host plot)
   (make-pathname :name (filename plot)
                  :type "data"
                  :directory (filepath plot))))

(defclass* gnuplot (plot-abstract)
  ((filename "plot" ia)
   (host nil ia)
   (filepath nil ia :initarg :directory))
  (:default-initargs
    :host *plot-default-host*
    :directory *plot-default-directory*)
  (:export-slots filename))

(defclass* plot-data-set ()
  ((settings (make-container 'simple-associative-container) r)
   (comment nil ia)
   (style nil ia)
   (data (make-container 'flexible-vector-container)
         #+Ignore
         (make-container 'list-container) 
         #+Ignore
         (make-container 'sorted-list-container
                         :key 'first :stable? t) r)))

(defmethod write-plot ((plot gnuplot) (style (eql :gnuplot)))
  (let ((pathname (fullpath plot))
        (first? t))
    (with-new-file (out pathname)
      (when (comment plot)
        (format out "# ~A~C" (comment plot) #\Linefeed))
      
      ;; settings
      (write-plot-settings plot out)
      
      ;; plot commands
      (let ((index 0))
        (iterate-elements-stably
         (data-sets plot)
         (lambda (data-set)
           (if first?
             (format out "plot")
             (format out ","))
           (format out " '-' with ~A " (style data-set))
           (write-plot-settings data-set out)
           (setf first? nil)
           (incf index))))
      (format out "~C" #\Linefeed)
      
      ;; data
      (setf first? t)
      (iterate-key-value-stably 
       (data-sets plot)
       (lambda (name data-set)
         (declare (ignore name))
         (write-data-set data-set out)
         (setf first? nil))))
    pathname))

(defmethod write-plot ((plot gnuplot) (style (eql :postscript)))
  (with-new-file (out (fullpath plot))
    (format out "set term push~C" #\Linefeed)
    (format out "set term postscript color~C" #\Linefeed)
    (format out "set output '~A.ps'~C" (filename plot) #\Linefeed))
  (let ((*file-if-exists* :append))
    (write-plot plot :gnuplot)
    (with-new-file (out (fullpath plot))
      (format out "set output~C" #\Linefeed)
      (format out "~Cset term pop~C" #\Linefeed #\Linefeed)
      (format out "!~Aps2pdf ~A.ps~C~C"
              *plot-ps2pdf-directory* (filename plot) #\Linefeed #\Linefeed)))
  plot) 

(defmethod write-plot-settings ((plot gnuplot) out)
  (let ((settings (settings plot)))
    (iterate-key-value
     (settings plot)
     (lambda (name value)
       (let ((it (find name *plot-plot-settings* :key 'first)))
	 (when it
	   (bind (((name &rest data) it)
		  ((:values name value) 
		   (handle-setting (first data) name data value)))
	     (when (and name value)
	       (format out "set ~(~A~) ~A~C" name 
		       (format-value-for-gnuplot name value)
		       #\Linefeed)))))))
    
    ;; handle range separately
    (when (or (item-at settings :xmin) (item-at settings :xmax))
      (format out "set xrange [~:[*~;~:*~A~]:~:[*~;~:*~A~]] ~C" 
              (item-at settings :xmin) (item-at settings :xmax) #\Linefeed))
    (when (or (item-at settings :ymin) (item-at settings :ymax))
      (format out "set yrange [~:[*~;~:*~A~]:~:[*~;~:*~A~]] ~C" 
              (item-at settings :ymin) (item-at settings :ymax) #\Linefeed))))

(defmethod write-plot-settings ((plot plot-data-set) out)
  (let ((first? t)
        (settings (settings plot)))
    (iterate-key-value
     settings
     (lambda (name value)
       (let ((it (find name *plot-data-set-settings* :key 'first))) 
	 (when it
	   (bind (((name &rest data) it)
		  ((:values name value)
		   (handle-setting (first data) name data value)))
	     (when (and name value)
	       (unless first?
		 (format out " "))
	       (format out "~(~A~) ~A" name 
		       (format-value-for-gnuplot name value))
	       (setf first? nil)))))))))

(defmethod write-data-set ((data-set plot-data-set) out)
  (iterate-elements
   (data data-set)
   (lambda (datum)
     (format out "~{~A ~}~C" datum #\Linefeed)))
  (format out "e~C" #\Linefeed))

(defmethod make-plot ((plot-kind symbol) data 
                      &rest args
                      &key name 
                      (comment nil)
                      (filename "plot")
                      (plot (make-instance 'gnuplot
                              :comment comment
                              :filename filename))
                      &allow-other-keys)
  (unless name (setf name (form-symbol "SET-" (1+ (size (data-sets plot))))))
  (when data
    (setf (item-at (data-sets plot) name)
          (apply #'make-data-set plot-kind data args)))
  (set-settings *plot-plot-settings* plot args)
  
  (values plot))

(defmethod make-data-set (plot-kind data
                          &rest args
                          &key (comment nil)
                          (filter (constantly t))
			  &allow-other-keys)
  (let ((data-set (make-instance 'plot-data-set
                    :comment comment
                    :style (plot-kind->plot-style plot-kind)))
        (point-kind (plot-kind->point-kind plot-kind)))
    (set-settings *plot-data-set-settings* data-set args)
    (iterate-elements
     data
     (lambda (datum)
       (when (funcall filter datum)  
         (insert-item (data data-set) 
                      (apply #'make-data-point point-kind datum args)))))
    #+(or) ;;not yet
    (when (or y-transform x-transform)
      )
    (values data-set)))

(defmethod make-data-point ((point-kind (eql :box)) datum
                            &key (x-coord 'first) (y-coord 'second) (width 0.5)
                            (offset nil)
                            &allow-other-keys)
  (append 
   (if x-coord 
     (list (+ (funcall x-coord datum)
              (if offset offset 0)))
     nil)
   (if y-coord (list (funcall y-coord datum)) nil)
   (list (determine-width width))))

(defmethod determine-width ((width number))
  (values width))

(defmethod determine-width ((width function))
  (funcall width))

(defmethod make-data-point ((point-kind (eql :point)) datum
                            &key (x-coord 'first) (y-coord 'second)
                            &allow-other-keys)
  (append 
   (if x-coord (list (funcall x-coord datum)) nil)
   (if y-coord (list (funcall y-coord datum)) nil)))

(defun set-settings (possibile-settings object settings)
  (loop for setting-info in possibile-settings do
        (bind (((name &rest nil) setting-info)
	       (it (getf settings name)))
          (when it
            (setf (item-at (settings object) name) it)))))

(defmethod handle-setting ((kind (eql nil)) name data value)
  (declare (ignore data))
  (values name value))

(defmethod handle-setting ((kind (eql :translate)) name data value)
  (declare (ignore name))
  (values (getf data :translate) value))

(defmethod handle-setting ((kind (eql :range)) name data value)
  (declare (ignore name data value))
  (values nil nil))

(defmethod format-value-for-gnuplot (name (value string))
  (declare (ignore name)) 
  (format nil "\"~A\"" (make-string-safe-for-unix value)))

(defmethod format-value-for-gnuplot (name (value symbol))
  (declare (ignore name)) 
  (format nil "~(~A~)" (symbol-name value)))

(defmethod format-value-for-gnuplot (name (value integer))
  (declare (ignore name)) 
  (format nil "~D" value))

(defmethod format-value-for-gnuplot (name (value number))
  (declare (ignore name)) 
  (format nil "~F" value))

(defmethod format-value-for-gnuplot (name (value list))
  (with-output-to-string (out)
    (dolist (thing value) 
      (format out "~A " (format-value-for-gnuplot name thing)))))


;;; ---------------------------------------------------------------------------
;;; plot kinds
;;; ---------------------------------------------------------------------------

(defun quick-plot (data &rest args &key
                        (plot-kind :points)
                        (x-coord 'first)
                        (y-coord 'second)
                        (key (constantly t))
                        (test 'equal)
                        (title "Scatter Plot")
                        (xlabel "")
                        (ylabel "")
                        (filename "scatter-plot")
                        (legend-creator (lambda (x) (format nil "~A" x)))
                        &allow-other-keys)
  (remf args :key)
  (bind ((result nil)
         (plot (apply #'make-plot nil nil 
                      :title title
                      :xlabel xlabel
                      :ylabel ylabel
                      :filename filename
                      args))
         (data-kinds (element-counts data :test test :key key :return :keys)))
    (iterate-elements
     data-kinds
     (lambda (data-kind)
       (push data-kind result)
       (apply #'make-plot plot-kind
                  (collect-elements
                   data
                   :filter (lambda (e) 
			     (funcall test data-kind (funcall key e))))
                  :x-coord x-coord
                  :y-coord y-coord
                  :plot plot
                  :legend (when legend-creator
			    (funcall legend-creator data-kind))
                  args)))
    (values plot)))

(defun scatter-plot (data &rest args &key
                          (x-coord 'first)
                          (y-coord 'second)
                          (key (constantly t))
                          (test 'equal)
                          (title "Scatter Plot")
                          (xlabel "")
                          (ylabel "")
                          (filename "scatter-plot")
                          (legend-creator (lambda (x) (format nil "~A" x)))
                          &allow-other-keys)
  (remf args :key)
  (bind ((result nil)
         (plot (apply #'make-plot nil nil 
                      :title title
                      :xlabel xlabel
                      :ylabel ylabel
                      :filename filename
                      args))
         (data-kinds (element-counts data :test test :key key :return :keys)))
    (iterate-elements
     data-kinds
     (lambda (data-kind)
       (push data-kind result)
       (apply #'make-plot :points
                  (collect-elements
                   data
                   :filter (lambda (e)
			     (funcall test data-kind (funcall key e))))
                  :x-coord x-coord
                  :y-coord y-coord
                  :plot plot
                  :legend (when legend-creator
			    (funcall legend-creator data-kind))
                  args)))
    (values plot)))

(defun histogram (data &rest args &key
                       (x-coord 'first)
                       (y-coord 'second)
                       (key (constantly t))
                       (title "Histogram")
                       (xlabel "")
                       (ylabel "")
                       (filename "histogram")
                       (legend-creator (lambda (x) (format nil "~A" x)))
                       (width 0.5)
                       &allow-other-keys)
  (remf args :key)
  (bind ((result nil)
         (plot (apply #'make-plot nil nil 
                      :title title
                      :xlabel xlabel
                      :ylabel ylabel
                      :filename filename
                      args))
         (data-kinds (element-counts data :key key :return :keys))
         (offset-delta 0.3)
         (offset (- offset-delta)))
    (iterate-elements
     data-kinds
     (lambda (data-kind)
       (push data-kind result)
       (make-plot :bar
                  (collect-elements
                   data
                   :filter (lambda (e) (eq data-kind (funcall key e))))
                  :x-coord x-coord
                  :y-coord y-coord
                  :plot plot
                  :width width
                  :offset (incf offset offset-delta)
                  :fill (list :solid 0.50)
                  :legend (when legend-creator
			    (funcall legend-creator data-kind)))))
    (values plot)))

(defun data->n-buckets (data bucket-count key &key bucket-center)
  (let ((min most-positive-double-float)
        (min-element nil)
        (max most-negative-double-float)
        (max-element nil))
    (declare (ignorable min-element max-element))
    (iterate-elements
     data
     (lambda (element)
       (let ((value (funcall key element)))
         (when (> value max) (setf max value max-element element))
         (when (< value min) (setf min value min-element element)))))
    
    (bind ((total-width (1+ (- max min)))
           (bucket-width (float (/ total-width bucket-count)))
           (buckets (make-array (ceiling bucket-count) :initial-element 0)))
      #+Ignore
      (incf bucket-width (/ bucket-width bucket-count))
      (iterate-elements
       data
       (lambda (element)
         (let ((value (funcall key element)))
           (incf (aref buckets (truncate (/ (- value min) bucket-width)))))))
      
      (values
       (let ((bucket-center (or bucket-center (+ min (/ bucket-width 2.0)))))
         (collect-elements
          buckets
          :transform
          (lambda (count)
            (prog1
              (list bucket-center count)
              (incf bucket-center bucket-width)))))
       bucket-width))))

#+Ignore
(open-plot-in-window 
 (histogram '((0 4) (1 177) (2 271) (3 201) (4 163)) :x-coord #'first :y-coord #'second))

#+Ignore
;; accumulates elements rather than just counting
(defun data->n-buckets (data bucket-count key)
  (let ((min most-positive-double-float)
        (min-element nil)
        (max most-negative-double-float)
        (max-element nil))
    (iterate-elements
     data
     (lambda (element)
       (let ((value (funcall key element)))
         (when (> value max) (setf max value max-element element))
         (when (< value min) (setf min value min-element element)))))
    
    (bind ((total-width (- max min))
           (bucket-width (float (/ total-width bucket-count)))
           (buckets (make-array bucket-count :initial-element nil)))
      (incf bucket-width (/ bucket-width bucket-count))
      (iterate-elements
       data
       (lambda (element)
         (let ((value (funcall key element)))
           (push element (aref buckets (truncate (/ (- value min) bucket-width)))))))
      
      (values
       (let ((bucket-center (+ min (/ bucket-width 2.0))))
         (collect-elements
          buckets
          :transform
          (lambda (elements)
            (prog1
              (list bucket-center (size elements) elements)
              (incf bucket-center bucket-width)))))
       bucket-width))))