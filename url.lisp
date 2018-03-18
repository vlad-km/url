;;; -*- mode:lisp; coding:utf-8 -*-

;;; Lisp interface for Node API URL
;;; Copyright  ©  2017,2018 Vladimir Mezentsev

(eval-when (:compile-toplevel :load-toplevel :execute)
    (unless (find :url *features*)
        (push :url *features*))
    (unless #j:url
        (setf #j:url (require "url"))) )


(defpackage #:url
  (:use #:cl)
  (:export #:parse #:resolve #:to-string))



(in-package :url)

;;;
;;; url.parse(urlStr, [parseQueryString], [slashesDenoteHost])
;;; Take a URL string, and return an object.
;;;
(defun parse (str &optional query slashes)
    (if query
        (#j:url:parse str query)
        (if slashes
            (#j:parse str query slashes)
            (#j:parse str))))


;;;
;;; url.resolve(from, to)
;;; Take a base URL, and a href URL, and resolve them as a browser would for an anchor tag.
;;;
(defun resolve (from to)
    (#j:url:resolve from to))


;;; url:format -> to-string
;;;
;;; (url:to-string :protocol "file" :pathname (concat (cwd) "//" "about.html"))
;;; => "file:///C:\\tmp\\abc\\about.html"
;;;
(defun to-string (&key href (protocol "file") host auth hostname port pathname query hash (slashes t))
    (let ((options))
        (flet ((mark (name val)
                   (if val (push (list name val) options))))
            (mark "href" href)
            (mark "protocol" protocol)
            (mark "host" host)
            (mark "auth" auth)
            (mark "hostname" hostname)
            (mark "port" port)
            (mark "pathname" pathname)
            (mark "query" query)
            (mark "hash" hash)
            (mark "slashes" slashes)
            (#j:url:format (apply 'jso:mk (reduce 'append options))))))

(in-package :cl-user)

;;; EOF
