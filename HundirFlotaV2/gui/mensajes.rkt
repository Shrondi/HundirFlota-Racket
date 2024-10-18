#lang s-exp lang/plt-pretty-big


(provide mensaje-dialogo-ganador)
(provide mensaje-informar-archivador)
(provide mensaje-nombre-tablero-jugador mensaje-nombre-tablero-CPU)
(provide mensaje-estado)
(provide mensaje-cronometro)
(provide mensaje-tamaño)

(require "dialogos.rkt")
(require "paneles.rkt")
(require "../macros.rkt")

(define mensaje-dialogo-ganador
  (new message%
       [label ""]
       [font (make-object font% 14 'default)]
       [parent dialogo-ganador]
       [min-height 50]
       [min-width 250]
       [auto-resize #t]
       [vert-margin 25]
       ))

(define mensaje-informar-archivador
  (new message%
       [label ""]
       [parent dialogo-guardar-tablero]
       [auto-resize #t]
       )
  )


(define mensaje-nombre-tablero-jugador
  (new message%
       [label "\t\t\tTu tablero"]
       [style '(deleted)]
       [parent panel-vertical-jugador]
       [vert-margin 0]
       [min-height cell-height]
       [min-width (/ anchura-tablero 2)]
       ))

(define mensaje-nombre-tablero-CPU
  (new message%
       [label "\t  Tablero del contrincante"]
       [style '(deleted)]
       [parent panel-vertical-CPU]
       [vert-margin 0]
       [min-height cell-height]
       [min-width (/ anchura-tablero 2)]	 
       ))

(define mensaje-estado
  (new message%
       [label "Posicione sus barcos"]
       [style '(deleted)]
       [font (make-object font% 13 'default 'normal 'book)]
       [parent panel-estado]	 
       [auto-resize #t]
       ))


(define mensaje-cronometro
  (new message%
       ;;[label "⏱ 0:00"]
       [label "0:00"]
       [style '(deleted)]
       [parent panel-estado]	 
       [auto-resize #t]
       ))

(define mensaje-tamaño
  (new message%
       ;;[label "🔍 100%"]
       [label "100%"]
       [style '(deleted)]
       [parent panel-encabezado]	 
       [auto-resize #f]
       ))


