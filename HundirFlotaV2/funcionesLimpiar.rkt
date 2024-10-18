#lang s-exp lang/plt-pretty-big

(provide limpiar-tablero)
(provide limpiar-canvas-tablero)
(provide limpiar-canvas-estado-flota)

(require "funcionesLogica.rkt")
(require "funcionesDibujar.rkt")

(define (limpiar-tablero dc dc-estado-flota flota-barcos-jugador plantilla-barcos)
  (reiniciar-tablero! flota-barcos-jugador)
  (reiniciar-plantilla-barcos! plantilla-barcos)
  (limpiar-canvas-tablero dc)
  (limpiar-canvas-estado-flota dc-estado-flota plantilla-barcos)
  )

(define (limpiar-canvas-tablero dc)
  (send dc clear)
  (dibujar-cuadricula dc)
  )

(define (limpiar-canvas-estado-flota dc plantilla-barcos)
  (send dc clear)
  (dibujar-flota-disponible dc plantilla-barcos)
  )