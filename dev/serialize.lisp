;;;-*- Mode: Lisp; Package: CLNUPLOT -*-

#| simple-header

$Id: comments-and-headers.lisp,v 1.5 2004/12/06 17:51:19 gwking Exp $

Copyright 1992 - 2005 Experimental Knowledge Systems Lab, 
University of Massachusetts Amherst MA, 01003-4610
Professor Paul Cohen, Director

Author: Gary King

DISCUSSION

|#
(in-package clnuplot)

(defmethod serialized-slots append-slots ((object plot-abstract))
  (slot-names object))

(defmethod serialized-slots append-slots ((object plot-data-set))
  (slot-names object))

(defmethod unserialized-slots append-slots ((object numbered-instances-mixin))
  '(object-number))