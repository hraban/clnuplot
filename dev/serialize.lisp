;;;-*- Mode: Lisp; Package: CLNUPLOT -*-

#| simple-header

Author: Gary King

DISCUSSION

|#
(in-package #:clnuplot)

(defmethod serialized-slots append-slots ((object plot-abstract))
  (slot-names object))

(defmethod serialized-slots append-slots ((object plot-data-set))
  (slot-names object))

(defmethod unserialized-slots append-slots ((object numbered-instances-mixin))
  '(object-number))