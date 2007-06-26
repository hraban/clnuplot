(in-package #:clnuplot)

(export '(roc! roc make-roc-plot make-roc-plot-template))

;;; ---------------------------------------------------------------------------

(defun roc! (examples count-positive count-negative f test 
                                    &key (weight (constantly 1))
                                    (beta nil) (sort? t))
  "Returns (as multiple values) a list of points for an ROC curve and a list of
f-measures associated with those points. The ROC curve algorithm is from Tom
Facwett's ROC Graphs: Notes and Practical Considerations for Data Mining Researchers.
See moab entry fawcett-roc-2003 for more information. 

If you know that the examples are already sorted, you can use the sort? keyword to
prevent this from sorting them again. The :beta keyword is passed along to the 
f-measure function. The :weight keyword is provided to handles aggreates of examples."
  (assert (plusp count-positive))
  (assert (plusp count-negative))
  (bind ((data (if sort? (sort examples #'> :key f) examples))
         (fp 0.0)
         (tp 0.0)
         (f-previous most-negative-fixnum)
         (points nil)
         (f-measures nil))
    (flet ((add-point (f-value)
             (push (list (/ fp count-negative) (/ tp count-positive)) points) 
             
             (push (and (or (plusp fp) (plusp tp))
                        (let ((precision (/ tp (+ fp tp)))
                              (recall (/ tp count-positive)))
                          (list 
                           ;;?? repeated test is a _little_ gross but ...
                           (if beta
                             (f-measure precision recall beta)
                             (f-measure precision recall))
                           precision recall f-value)))
                   f-measures)))
      (loop for example in data do
            (let ((estimate (funcall f example)))
              (when (/= f-previous estimate) 
                (add-point estimate)
                (setf f-previous estimate))
              (if (funcall test example)
                (incf tp (funcall weight example)) 
                (incf fp (funcall weight example)))))
      (add-point 1.0))
    
    (values (nreverse points)
            (nreverse f-measures))))

;;; ---------------------------------------------------------------------------

(defun roc (examples count-positive count-negative f test
                                   &key (weight (constantly 1)))
  (roc! (copy-list examples) count-positive count-negative f test
        :weight weight))

#+Test
(let ((data '(((p y) 0.99999)
              ((p y) 0.99999)
              ((p y) 0.99993)
              ((p y) 0.99986)
              ((p y) 0.99964)
              ((p y) 0.99955)
              ((n y) 0.68139)
              ((n y) 0.50961)
              ((n n) 0.48880)
              ((n n) 0.44951))))
  #+Old
  (roc data 8 2 (lambda (ex) (eq 'y (second ex))))
  (make-roc-plot data 8 2 (lambda (ex) (eq 'y (second ex))) 
                 :title "Example ROC plot from Tom Fawcett's paper"
                 :width 2))


;;; ---------------------------------------------------------------------------

#+Test
(let ((data '((p 0.9)
              (p 0.8)
              (n 0.7)
              (p 0.6)
              (p 0.55)
              (p 0.54)
              (n 0.53)
              (n 0.52)
              (p 0.51)
              (n 0.505)
              (p 0.4)
              (n 0.39)
              (p 0.38)
              (n 0.37)
              (n 0.36)
              (n 0.35)
              (p 0.34)
              (n 0.33)
              (p 0.30)
              (n 0.1))))
  #+Old
  (roc data 8 2 (lambda (ex) (eq 'y (second ex))))
  (make-roc-plot (roc data 10 10 #'second (lambda (datum) (eq 'p (first datum))))
                 "test-roc-plot"
                 :title "Example ROC plot from Tom Fawcett's paper"
                 :linewidth 2))


;;; ---------------------------------------------------------------------------

#|
((1 2) ...)
(((1 2) ...) ((3 4) ...))
((((1 2) ...) :a b :c d) (((3 4) ...) :d e :f g))
|#

(defun make-roc-plot-template (&rest args
                               &key
                               (filename "roc-curve")
                               (title "ROC Curve")
                               (xlabel "False negative rate")
                               (ylabel "True positive rate")
                               (key '(bottom right))
                               &allow-other-keys)
  (apply #'make-plot nil nil
         :title title
         :xlabel xlabel
         :ylabel ylabel
         :xmin 0
         :ymin 0
         :xmax 1
         :ymax 1
         :size 'square
         :key key
         :filename filename
         args))

;;; ---------------------------------------------------------------------------

(defun make-roc-plot (data &rest args
                           &key
                           plot
                           (linewidth 2)
                           &allow-other-keys)
  "Data can either be a single plot or multiple plots. In the first case, it should 
be a list of pairs of numbers; in the second it should be a list of lists of pairs of
numbers."
  (let ((plot (or plot (apply #'make-roc-plot-template args))))
    (flet ((do-plot (points &rest args)
             (apply #'make-plot :lines-and-points points
                    :plot plot
                    :linewidth linewidth
                    args)))
      (cond ((and (consp data) 
		  (length-at-most-p (first data) 2)
		  (length-at-least-p (first data) 2)
                  (numberp (caar data)))
             ;; single plot
             ;; ((1 2) ...)
             (do-plot data))
            ((and (consp data) (every-element-p data #'consp))
             ;; multiple plots
             (dolist (points data) 
               (if (and (length-exactly-p (first points) 2)
                        (numberp (caar points)))
                 ;; (((1 2) ...) ((3 4) ...))
                 (do-plot points)
                 ;; ((((1 2) ...) :a b :c d) (((3 4) ...) :d e :f g))
                 (apply #'do-plot (first points) (rest points)))))
            (t
             (error "Unknown data format"))))
    
    (values plot)))

