#lang s-exp lang/plt-pretty-big

(provide callback-on-close)

(require "../mensajes.rkt")
(require "../textos.rkt")
(require "../botones.rkt")


(define (callback-on-close)

  (send mensaje-informar-archivador set-label "")
  
  (send texto-nombre-tablero set-value "")
  (send texto-nombre-fichero set-value "")
  (send texto-descripcion-tablero set-value "")
  
  (send texto-nombre-tablero set-field-background #f)
  (send texto-nombre-fichero set-field-background #f)
  (send texto-descripcion-tablero set-field-background #f)

  (send boton-guardar-fichero enable #f)
  )