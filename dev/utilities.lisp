#| simple-header

Author: Gary King

DISCUSSION

|#
(in-package #:clnuplot)

(defun make-string-safe-for-unix (string)
  (let ((result (make-array (* (length string) 2)
			    :fill-pointer 0 :adjustable t)))
    (flet ((add-char (char)
             (setf (aref result (length result)) char)
             (incf (fill-pointer result))))
      (loop for char across string do
            (cond ((char= #\" char)
                   (add-char #\\)
                   (add-char #\"))
                  (t
                   (add-char char)))))
    (coerce result 'string)))

#+Test
(make-string-safe-for-unix "hello there")
#+Test
(make-string-safe-for-unix "hello there, I'm Bob.")

;;; ---------------------------------------------------------------------------

(defun plot-kind->plot-style (plot-kind)
  (ecase plot-kind
    (:line   "lines")
    (:bar    "boxes")
    (:points "points")
    ((:lines-points :lines-and-points) "linespoints")))

;;; ---------------------------------------------------------------------------

(defun plot-kind->point-kind (plot-kind)
  (ecase plot-kind
    ((:line :points :lines-points :lines-and-points)
     :point)
    (:bar
     :box)))
