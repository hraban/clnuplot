;;;-*- Mode: Lisp; Package: CLNUPLOT -*-

#| simple-header

$Id: utilities.lisp,v 1.1 2005/05/24 17:11:19 gwking Exp $

Copyright 1992 - 2005 Experimental Knowledge Systems Lab, 
University of Massachusetts Amherst MA, 01003-4610
Professor Paul Cohen, Director

Author: Gary King

DISCUSSION

|#
(in-package clnuplot)

(defun make-string-safe-for-unix (string)
  (let ((result (make-array (* (length string) 2) :fill-pointer 0 :adjustable t)))
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