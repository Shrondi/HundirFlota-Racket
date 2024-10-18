#lang s-exp lang/plt-pretty-big

(require "gui/botones.rkt")
(require "gui/ventana.rkt")

(send ventana-principal center 'both)

(if (not (directory-exists? "archivo-tableros"))
         (make-directory "archivo-tableros"))



;;(collect-garbage 'incremental)


(send ventana-principal show #t)

